function P = normal_likelihood_(VQ_pred, VQ_obs, std_VQ)
  % likelihood of observing a predicted value
    chisq = ((VQ_pred - VQ_obs)/std_VQ).^2;
    P = 1./(std_VQ * sqrt(2*pi)) .* exp( - 0.5 * chisq);
end
