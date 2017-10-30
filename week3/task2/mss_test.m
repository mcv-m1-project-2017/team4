function [ regionProposal ]  = mss_test( iMask )
  [cancellingMask, regionProposal] = multiscaleSearch(iMask, geometricFeatures, params);
end