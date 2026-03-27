import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../utils/global.dart';
import '../widgets/easy_overlay/easy_overlay.dart';
import 'ad_units.dart';
import 'rewarded_alert.dart';

class AdHelper {
  static InterstitialAd? _interstitialAd;
  static bool _interstitialAdLoaded = false;
  static bool _isInterstitialLoading = false;

  static RewardedAd? _rewardedAd;
  static bool _rewardedAdLoaded = false;
  static bool _isRewardedLoading = false;

  // Retry
  static const int _maxRetries = 3;
  static int _interstitialRetryCount = 0;
  static int _rewardedRetryCount = 0;

  // ============================================
  // Interstitial Ad
  // ============================================

  static bool interstitialAdLoaded() =>
      _interstitialAdLoaded && _interstitialAd != null;

  static void precacheInterstitialAd() {
    if (Global.offAds || _isInterstitialLoading || _interstitialAdLoaded) {
      return;
    }
    _isInterstitialLoading = true;

    InterstitialAd.load(
      adUnitId: AdUnits.interstitial,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              _resetInterstitialAd();
              precacheInterstitialAd();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              log('Interstitial failed to show: ${error.message}');
              _resetInterstitialAd();
              precacheInterstitialAd();
            },
          );
          _interstitialAd = ad;
          _isInterstitialLoading = false;
          _interstitialAdLoaded = true;
          _interstitialRetryCount = 0;
        },
        onAdFailedToLoad: (err) {
          _resetInterstitialAd();
          log('Failed to load interstitial: ${err.message}');
          _retryInterstitial();
        },
      ),
    );
  }

  static void _resetInterstitialAd() {
    _interstitialAd?.dispose();
    _interstitialAd = null;
    _isInterstitialLoading = false;
    _interstitialAdLoaded = false;
  }

  static void _retryInterstitial() {
    if (_interstitialRetryCount >= _maxRetries) {
      log('Interstitial max retries reached');
      _interstitialRetryCount = 0;
      return;
    }
    _interstitialRetryCount++;
    Future.delayed(
      Duration(seconds: _interstitialRetryCount * 3),
      precacheInterstitialAd,
    );
  }

  static void showInterstitialAd({required VoidCallback onComplete}) {
    if (Global.offAds) {
      onComplete();
      return;
    }

    if (interstitialAdLoaded()) {
      _interstitialAd?.show().then((_) => onComplete());
      return;
    }

    precacheInterstitialAd();
    onComplete();
  }

  // ============================================
  // Rewarded Ad
  // ============================================

  static bool rewardedAdLoaded() => _rewardedAdLoaded && _rewardedAd != null;

  static void precacheRewardedAd() {
    if (Global.offAds || _isRewardedLoading || _rewardedAdLoaded) return;
    _isRewardedLoading = true;

    RewardedAd.load(
      adUnitId: AdUnits.rewarded,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              _resetRewardedAd();
              precacheRewardedAd();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              log('Rewarded failed to show: ${error.message}');
              _resetRewardedAd();
              precacheRewardedAd();
            },
          );
          _rewardedAd = ad;
          _isRewardedLoading = false;
          _rewardedAdLoaded = true;
          _rewardedRetryCount = 0;
        },
        onAdFailedToLoad: (err) {
          _resetRewardedAd();
          log('Failed to load rewarded: ${err.message}');
          _retryRewarded();
        },
      ),
    );
  }

  static void _resetRewardedAd() {
    _rewardedAd?.dispose();
    _rewardedAd = null;
    _isRewardedLoading = false;
    _rewardedAdLoaded = false;
  }

  static void _retryRewarded() {
    if (_rewardedRetryCount >= _maxRetries) {
      log('Rewarded max retries reached');
      _rewardedRetryCount = 0;
      return;
    }
    _rewardedRetryCount++;
    Future.delayed(
      Duration(seconds: _rewardedRetryCount * 3),
      precacheRewardedAd,
    );
  }

  static void showRewardedAd({required VoidCallback onComplete}) {
    if (Global.offAds) {
      onComplete();
      return;
    }

    if (rewardedAdLoaded()) {
      EasyOverlay.show(
        child: RewarededAlert(
          watch: () {
            _rewardedAd?.show(
              onUserEarnedReward: (AdWithoutView ad, RewardItem rewardItem) {
                onComplete();
              },
            );
          },
        ),
      );
      return;
    }

    precacheRewardedAd();
    onComplete();
  }
}
