function plot_fit_results(results)
  figure()
  subplot(2,2,1)
  loglog(results.delta_2d(:), results.misfit_Q(:),'.', 'markersize',12)
  xlabel('delta')
  ylabel('Q misfit')
  subplot(2,2,2)
  loglog(results.delta_2d(:), results.misfit_M(:),'.', 'markersize',12)
  xlabel('delta')
  ylabel('M misfit')

  subplot(2,2,3)
  loglog(results.alpha_2d(:), results.misfit_Q(:),'.', 'markersize',12)
  xlabel('alpha')
  ylabel('Q misfit')
  subplot(2,2,4)
  loglog(results.alpha_2d(:), results.misfit_M(:),'.', 'markersize',12)
  xlabel('alpha')
  ylabel('M misfit')

  figure()
  subplot(1,2,1)
  loglog(results.delta_2d(:), results.misfit_joint(:),'.', 'markersize',12)
  xlabel('delta')
  ylabel('joint misfit')
  subplot(1,2,2)
  loglog(results.alpha_2d(:), results.misfit_joint(:),'.', 'markersize',12)
  xlabel('alpha')
  ylabel('joint misfit')


  figure()
  r = results;
  contourf(log10(r.delta_draws), log10(r.alpha_draws), log10(r.misfit_Q),20)
  colorbar()
  xlabel('log10(delta)')
  ylabel('log10(alpha)')
  title('log10(Q misfit)')

  figure()
  r = results;
  contourf(log10(r.delta_draws), log10(r.alpha_draws), log10(r.misfit_M),20)
  colorbar()
  xlabel('log10(delta)')
  ylabel('log10(alpha)')
  title('log10 (M misfit)')

  figure()
  r = results;
  contourf(log10(r.delta_draws), log10(r.alpha_draws), log10(r.misfit_joint),20)
  colorbar()
  xlabel('log10(delta)')
  ylabel('log10(alpha)')
  title('log10(joint misfit)')

end
