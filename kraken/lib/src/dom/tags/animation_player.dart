/*
 * Copyright (C) 2019-present Alibaba Inc. All rights reserved.
 * Author: Kraken Team.
 */

import 'package:flare_flutter/provider/asset_flare.dart';
import 'package:flare_flutter/flare_controls.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:kraken/css.dart';
import 'package:kraken/dom.dart';
import 'package:kraken/rendering.dart';

const String ANIMATION_PLAYER = 'ANIMATION-PLAYER';
const String ANIMATION_TYPE_FLARE = 'flare';

final Map<String, dynamic> _defaultStyle = {
  WIDTH: ELEMENT_DEFAULT_WIDTH,
  HEIGHT: ELEMENT_DEFAULT_HEIGHT,
};

// Ref: https://github.com/LottieFiles/lottie-player
class AnimationPlayerElement extends Element {

  RenderObject _animationRenderObject;
  FlareControls _animationController;

  AnimationPlayerElement(int targetId, ElementManager elementManager)
      : super(targetId, elementManager, tagName: ANIMATION_PLAYER, defaultStyle: _defaultStyle, isIntrinsicBox: true, repaintSelf: true);

  String get objectFit => style[OBJECT_FIT];

  // Default type to flare
  String get type => properties['type'] ?? ANIMATION_TYPE_FLARE;

  String get src => properties['src'];

  @override
  void willAttachRenderer() {
    super.willAttachRenderer();

    _animationRenderObject = _createFlareRenderObject();
    if (_animationRenderObject != null) {
      addChild(_animationRenderObject);
    }
  }

  @override
  void didDetachRenderer() {
    _animationRenderObject = null;
  }

  void _updateRenderObject() {
    if (isConnected && isRendererAttached) {
      RenderObject prev = previousSibling?.renderer;

      detach();
      attachTo(parent, after: prev);
    }
  }

  void _play(List args) {
    assert(args[0] is String);
    String name = args[0];
    double mix = 1.0;
    double mixSeconds = 0.2;
    if (args.length > 1 && args[1] != null) {
      assert(args[1] is Map);
      Map options = args[1];
      if (options.containsKey('mix')) {
        mix = CSSLength.toDouble(options['mix']) ?? 0.0;
      }
      if (options.containsKey('mixSeconds')) {
        mix = CSSLength.toDouble(options['mixSeconds']) ?? 0.0;
      }
    }
    _animationController?.play(name, mix: mix, mixSeconds: mixSeconds);
  }

  void _updateObjectFit() {
    if (_animationRenderObject is FlareRenderObject) {
      FlareRenderObject renderBox = _animationRenderObject;
      renderBox?.fit = _getObjectFit();
    }
  }

  @override
  void setProperty(String key, value) {
    super.setProperty(key, value);

    _updateRenderObject();
  }

  @override
  void setStyle(String key, value) {
    super.setStyle(key, value);
    if (key == OBJECT_FIT) {
      _updateObjectFit();
    }
  }

  @override
  method(String name, List args) {
    switch (name) {
      case 'play':
        _play(args);
        break;
      default:
        super.method(name, args);
    }
  }

  BoxFit _getObjectFit() {
    switch (objectFit) {
      case 'fill':
        return BoxFit.fill;
        break;
      case 'cover':
        return BoxFit.cover;
        break;
      case 'fit-height':
        return BoxFit.fitHeight;
        break;
      case 'fit-width':
        return BoxFit.fitWidth;
        break;
      case 'scale-down':
        return BoxFit.scaleDown;
        break;
      case 'contain':
      default:
        return BoxFit.contain;
    }
  }

  FlareRenderObject _createFlareRenderObject() {
    if (src == null) {
      return null;
    }

    BoxFit boxFit = _getObjectFit();
    _animationController = FlareControls();

    return FlareRenderObject()
      ..assetProvider = AssetFlare(bundle: NetworkAssetBundle(Uri.parse(src)), name: '')
      ..fit = boxFit
      ..alignment = Alignment.center
      ..animationName = properties['name']
      ..shouldClip = false
      ..useIntrinsicSize = true
      ..controller = _animationController;
  }
}
