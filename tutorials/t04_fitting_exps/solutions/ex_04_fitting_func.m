function results = ex_04_fitting_func()
  % a brutish minimization

  path_to_top_level_vbr=getenv('vbrdir');
  addpath(path_to_top_level_vbr)
  vbr_init('quiet', 1)

  addpath('helper_funcs')

  % read in our "experimental data"
  experiments = create_fake_data(0);

  % brute force grid search (start with small number of elements...)
  N_draws_al = 90;
  alpha_draws = logspace(-2, 0, N_draws_al);

  N_draws_del = 100;
  delta_draws = logspace(-1, 2, N_draws_del);

  % for each combo, predict observations from VBRc
  misfit_Q = zeros(N_draws_al, N_draws_del);
  misfit_M = zeros(N_draws_al, N_draws_del);
  M_obs = experiments.obs.M;
  M_std = experiments.obs.M_std;
  Q_obs = experiments.obs.Q;
  Q_std = experiments.obs.Q_std;

  for alpha_i = 1:N_draws_al
    disp(['processing alpha draw ', num2str(alpha_i) , ' of ', num2str(N_draws_al)])
    for delta_i = 1:N_draws_del
      VBR = call_VBRc(alpha_draws(alpha_i), delta_draws(delta_i), experiments.SV);

      % misfit for each experimental state
      dM = misfit_func(VBR.out.anelastic.tasty_burgers.M, M_obs, M_std);
      dQ = misfit_func(VBR.out.anelastic.tasty_burgers.Q, Q_obs, Q_std);

      % single misfit for these parameters
      misfit_M(alpha_i, delta_i) = sum(dM(:));
      misfit_Q(alpha_i, delta_i) = sum(dQ(:));
    end
  end

  results.misfit_M = misfit_M;
  results.misfit_Q = misfit_Q;
  results.misfit_joint = misfit_M + misfit_Q;
  results.delta_draws = delta_draws;
  results.alpha_draws = alpha_draws;
  [d_2d, a_2d] = meshgrid(results.delta_draws, results.alpha_draws);
  results.delta_2d = d_2d;
  results.alpha_2d = a_2d;
  results.experiments = experiments;

  plot_fit_results(results)

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % everything above working?
  %
  % try a higher resolution run (100 draws for each runs in ~5 mins on my
  % desktop in octave).
  %
  % general questions:
  %
  % what alpha and delta values are you finding and why are we getting those
  % values? (hint: where is our "data" coming from?)
  %
  % how do the misfits for M and Q compare? why are they different?
  %
  % how could you improve the fit?
  %
  % extra exercises:
  %
  % write some more code to extract numerical alpha, delta values (including
  % uncertainties?)
  %
  % modify the uncertainty of the observations (in `create_fake_data`) and see
  % what happens to your fit.
  %

end

function dM = misfit_func(Mpred, Mobs, M_std)
    dM = ((log10(Mpred) - log10(Mobs)) ./ log10(M_std)).^2;
end

function VBR = call_VBRc(alpha_i, delta_i, SV)
    % calls the VBRc with the provided model parameters for the
    % experimental thermodynamic state variables
    VBR = struct();
    VBR.in.SV = SV;

    VBR.in.elastic.methods_list = {'anharmonic'};
    VBR.in.anelastic.methods_list = {'tasty_burgers'};

    % load in params, set the trial alpha, delta
    VBR.in.anelastic.tasty_burgers = Params_Anelastic('tasty_burgers');
    VBR.in.anelastic.tasty_burgers.alpha = alpha_i;
    VBR.in.anelastic.tasty_burgers.delta = delta_i;

    % call it!
    VBR = VBR_spine(VBR);

end
