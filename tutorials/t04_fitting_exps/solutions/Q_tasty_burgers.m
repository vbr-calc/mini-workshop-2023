function [VBR] = Q_tasty_burgers(VBR)

  % https://vbr-calc.github.io/vbr/contrib/newmethod/

  % some rules:
  %     - functions can only have VBR structure as input/output
  %     - functions should handle state variable arrays of any shape
  %     - any frequency dependence should map to a new dimension
  %     - output fieldnames are standardized for different property types
  %       (see end of this file for a list for anelastic methods)

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % initializing

  % pointers to relevant state variables from VBR.in.SV
  T_K = VBR.in.SV.T_K;
  dg_um = VBR.in.SV.dg_um;
  sig_MPa = VBR.in.SV.sig_MPa;
  f_vec = VBR.in.SV.f ;  % frequency [Hz]

  % VBR.out. will have both .elastic and .viscous calculations complete if they
  % were specified. Can specify dependencies in vbr/vbrCore/functions/checkInput.m
  % to get useful error messages and optionally add defaults
  if isfield(VBR.in.elastic,'anh_poro')
      Mu = VBR.out.elastic.anh_poro.Gu ;
  elseif isfield(VBR.in.elastic,'anharmonic')
      Mu = VBR.out.elastic.anharmonic.Gu ;
  end

  % pointer to parameters structure, parameters
  my_new_params = VBR.in.anelastic.tasty_burgers;
  FLP = my_new_params.FLP;
  alpha = my_new_params.alpha;
  delta = my_new_params.delta;

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % intermediate calculations (generally, not frequency-dependent calculations)

  Ju = 1./Mu ;  % unrelaxed compliance
  w_vec = 2*pi.*f_vec ;  % angular frequency

  % steady state viscosity, maxwell time
  R = 8.314 ; % gas constant
  sr = FLP.A .* (sig_MPa.^FLP.n) .* (dg_um.^(-FLP.p)) .* exp(-FLP.Q ./ (R.*T_K));
  eta_ss = sig_MPa ./ sr;
  tau_maxwell = eta_ss .* Ju;

  % maxwell time integration limits
  tau_low = tau_maxwell * my_new_params.tau_low_factor;
  tau_high = tau_maxwell * my_new_params.tau_high_factor;

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % frequency-dependent calculations

  % initialize empty arrays of expected output size
  n_th = numel(T_K); % total elements
  input_size = size(T_K);
  n_freq = numel(f_vec);
  Q = proc_add_freq_indeces(zeros(input_size), n_freq);
  output_size = size(Q);
  J1 = zeros(output_size);
  J2 = zeros(output_size);

  % your calculations
  for istate = 1:n_th

    mxwl = tau_maxwell(istate);

    % relaxation function for this thermodynamic state: integration limits change
    % for each thermodynamic state :(
    tau_high_i = tau_high(istate);
    tau_low_i = tau_low(istate);
    tau_trial_vec = logspace(log10(tau_low_i), log10(tau_high_i), 1000);
    Db = alpha .* tau_trial_vec.^(alpha-1) ./ (tau_high_i.^alpha - tau_low_i.^alpha);

    for ifreq = 1:numel(f_vec)

      % the linear index of the arrays with a frequency index:
      i_glob = istate + (ifreq - 1) * n_th;
      w = w_vec(ifreq);

      % calculate J1
      Db_func = Db ./ (1 + w * w * tau_trial_vec.^2);
      int_J1 = trapz(tau_trial_vec, Db_func);
      J1(i_glob) = Ju(istate) * (1+delta.*int_J1);

      % calculate J2
      Db_func = tau_trial_vec .* Db_func;
      int_J2 = trapz(tau_trial_vec, Db_func);
      J2(i_glob) = Ju(istate) * (w*delta.*int_J2 + 1/(w*mxwl));

    end
  end

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % store in output

  VBR.out.anelastic.tasty_burgers = struct();
  VBR.out.anelastic.tasty_burgers.J1 = J1;
  VBR.out.anelastic.tasty_burgers.J2 = J2;
  VBR.out.anelastic.tasty_burgers.Q = J1 ./ J2;
  VBR.out.anelastic.tasty_burgers.M = (J1.^2 + J2.^2).^(-0.5);

  VBR.out.anelastic.tasty_burgers.tau_M = tau_maxwell;
  VBR.out.anelastic.tasty_burgers.units = Q_method_units();
  VBR.out.anelastic.tasty_burgers.eta_ss = eta_ss;
  % anelastic method conventions for output variables!
  %
  % VBR.out.anelastic.tasty_burgers.
  %
  % frequency dependent variables:
  %   J1, J2 : frequency dependent storage and loss modulus in 1/Pa
  %   Q : quality factor
  %   Qinv: attenutation (1/Q)
  %   M: (shear) modulus in Pa
  %   V: shear wave velocity in m/s
  %
  % frequency independent variables
  %   tau_M: maxwell time in s
  %   Vave: average shear wave velocity across frequencies
  %
  % other expected variables
  %   units: a structure containing the units of the output field.
  %          can use VBR.out.anelastic.tasty_burgers.units = Q_method_units();
  %          for populating units fields for the standard fields.
  %          e.g.,
  %          units.V = 'm/s';
  %          units.Q = ''; % for nondimensional fields
  %
  %          any non-standard fields should have corresponding units entries.

end
