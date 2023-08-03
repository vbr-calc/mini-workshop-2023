function results = ex_04_fitting_func()
  % a brutish minimization

  path_to_top_level_vbr=getenv('vbrdir');
  addpath(path_to_top_level_vbr)
  vbr_init('quiet', 1)

  % read in our "experimental data"
  addpath('helper_funcs')
  experiments = create_fake_data(0);

  % brute force grid search (start with small number of elements...)
  N_draws_al = 10;
  alpha_draws = logspace(-2, 0, N_draws_al);

  N_draws_del = 9;
  delta_draws = logspace(-1, 2, N_draws_del);

  % for each combo, predict observations from VBRc
  misfit_Q = zeros(N_draws_al, N_draws_del);
  misfit_M = zeros(N_draws_al, N_draws_del);

  % read in the experimental observations
  M_obs = ;
  M_std = ;
  Q_obs = ;
  Q_std = ;
  SV = ;

  for alpha_i = 1:N_draws_al
    disp(['processing alpha draw ', num2str(alpha_i) , ' of ', num2str(N_draws_al)])
    for delta_i = 1:N_draws_del
      VBR = call_VBRc( what arguments do you need?);

      % calculate misfit in M, Q for each experimental state
      dM = misfit_func(... args ... ? );
      dQ = misfit_func(... args ... ? );

      % single misfit across experimental states for these model parameters
      misfit_M(alpha_i, delta_i) = ;
      misfit_Q(alpha_i, delta_i) = ;
    end
  end

  results.misfit_M = misfit_M;
  results.misfit_Q = misfit_Q;

  % calculate a joint misfit
  results.misfit_joint = ;

  % storing results for plotting convenience
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

function misfit = misfit_func(pred, obs, std_val)

    % a function to calculate the misfit between a prediction and an observation

end

function VBR = call_VBRc(what arguments do you need?)

    % call the VBRc for the current guess at alpha, delta, return the resulting
    % VBR structure

end
