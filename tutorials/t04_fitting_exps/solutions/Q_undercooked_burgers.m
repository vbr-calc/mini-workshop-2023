function [VBR] = Q_undercooked_burgers(VBR)

  disp('hello!')
  % https://vbr-calc.github.io/vbr/contrib/newmethod/

  % some rules:
  %     - functions can only have VBR structure as input/output
  %     - functions should handle state variable arrays of any shape
  %     - any frequency dependence should map to a new dimension
  %     - output fieldnames are standardized for different property types
  %       (see end of this file for a list for anelastic methods)

  % pointers to relevant state variables from VBR.in.SV
  T_K = VBR.in.SV.T_K;
  f_vec = VBR.in.SV.f ;  % frequency [Hz]
  w_vec = 2*pi.*f_vec ;  % angular frequency

  % pointers to existing VBRc calculations
  % VBR.out. will have both .elastic and .viscous calculations complete if they
  % were specified by user, can extract them in this function.
  % Can also specify dependencies in vbr/vbrCore/functions/checkInput.m
  % to get useful error messages and optionally add defaults.
  if isfield(VBR.in.elastic,'anh_poro')
      Mu = VBR.out.elastic.anh_poro.Gu ;
  elseif isfield(VBR.in.elastic,'anharmonic')
      Mu = VBR.out.elastic.anharmonic.Gu ;
  else
      error(' :( missing elastic calculation')
  end

  % pointer to parameters structure
  my_new_params = VBR.in.anelastic.tasty_burgers;
  disp('hey, check these nice parameters: ')
  disp(my_new_params)

  % initialize arrays of expected output size
  n_th = numel(T_K); % total elements
  input_size = size(T_K);
  n_freq = numel(f_vec);
  Q = proc_add_freq_indeces(zeros(input_size), n_freq);

  % your calculations
  for ifreq = 1:numel(f_vec)
    % get linear index of J1, J2, etc.
    ig1 = 1+(ifreq - 1) * n_th; % the first linear index in current frequency
    ig2 = (ig1-1)+ n_th; % the last linear index in current frequency

    % not a physically relevant equation:
    Q(ig1:ig2) = T_K * my_new_params.n * f_vec(ifreq) + ...
                 my_new_params.Delta * exp(-((T_K - 1000)/300).^2) + Mu/1e9;
  end

  % store in output
  VBR.out.anelastic.tasty_burgers = struct();
  VBR.out.anelastic.tasty_burgers.Q = Q;

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
