function experiments = create_fake_data(make_plots)
    path_to_top_level_vbr=getenv('vbrdir');
    addpath(path_to_top_level_vbr)
    vbr_init('quiet', 1)

    % experimental conditions
    T_K = linspace(800,1400,10)+273;
    dg_um = [10, 20, 50];
    [T_K, dg_um] = meshgrid(T_K, dg_um);
    experiments.SV.T_K = T_K;
    experiments.SV.dg_um = dg_um;
    sz = size(experiments.SV.dg_um);
    experiments.SV.sig_MPa = 1 * ones(sz);
    experiments.SV.rho = 3300 * ones(sz);  % only needed so anharmonic doesnt error
    experiments.SV.P_GPa = 0.1 * ones(sz);

    experiments.SV.f  = [.01, .1, 1];

    % use the existing parameters to get some output
    VBR = struct();
    VBR.in.SV = experiments.SV;
    VBR.in.elastic.methods_list = {'anharmonic'};
    VBR.in.anelastic.methods_list = {'tasty_burgers'};
    VBR = VBR_spine(VBR);

    % pull out M, Q, add some noise and use those our observed data
    M = VBR.out.anelastic.tasty_burgers.M;
    Q = VBR.out.anelastic.tasty_burgers.Q;
    M = make_noisy(M, 0.05 * M);
    Q = make_noisy(Q, .01 * Q);
    experiments.obs.Q = Q;
    experiments.obs.Q_std = Q * 0.01; % std uncertainty in measurement
    experiments.obs.M = M;
    experiments.obs.M_std = M * 0.01; % std uncertainty in measurement

    if make_plots == 1

      for idg = 1:sz(1)
        subplot(1,2,1)
        hold all
        semilogy(experiments.SV.T_K(idg,:), experiments.obs.M(idg,:,1))
        xlabel('T [K]')
        ylabel('M [Pa]')

        subplot(1,2,2)
        hold all
        semilogy(experiments.SV.T_K(idg,:), experiments.obs.Q(idg,:,1))
        xlabel('T [K]')
        ylabel('Q')

      end
    end

end


function noisy_x = make_noisy(x, noise_magnitude)
   sz = size(x);
   rand_x = 2 * rand(sz) -1; % between [-1, 1]
   randsign = sign(rand_x);
   magval = randsign .* noise_magnitude;
   noisy_x = x + magval;
end
