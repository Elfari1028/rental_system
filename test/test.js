define(['dart_sdk', 'packages/flutter/src/widgets/widget_span.dart', 'packages/flutter/src/animation/animation_controller.dart', 'packages/flutter/src/animation/listener_helpers.dart', 'packages/flutter/src/animation/curves.dart', 'packages/flutter/src/painting/box_decoration.dart', 'packages/flutter/src/material/colors.dart', 'packages/flutter/src/material/icon_button.dart', 'packages/flutter/src/material/progress_indicator.dart', 'packages/cabin/base/provider.dart'], function (dart_sdk, packages__flutter__src__widgets__widget_span$46dart, packages__flutter__src__animation__animation_controller$46dart, packages__flutter__src__animation__listener_helpers$46dart, packages__flutter__src__animation__curves$46dart, packages__flutter__src__painting__box_decoration$46dart, packages__flutter__src__material__colors$46dart, packages__flutter__src__material__icon_button$46dart, packages__flutter__src__material__progress_indicator$46dart, packages__cabin__base__provider$46dart) {
    'use strict';
    const core = dart_sdk.core;
    const _js_helper = dart_sdk._js_helper;
    const ui = dart_sdk.ui;
    const async = dart_sdk.async;
    const dart = dart_sdk.dart;
    const dartx = dart_sdk.dartx;
    const framework = packages__flutter__src__widgets__widget_span$46dart.src__widgets__framework;
    const container = packages__flutter__src__widgets__widget_span$46dart.src__widgets__container;
    const transitions = packages__flutter__src__widgets__widget_span$46dart.src__widgets__transitions;
    const basic = packages__flutter__src__widgets__widget_span$46dart.src__widgets__basic;
    const widget_inspector = packages__flutter__src__widgets__widget_span$46dart.src__widgets__widget_inspector;
    const navigator = packages__flutter__src__widgets__widget_span$46dart.src__widgets__navigator;
    const ticker_provider = packages__flutter__src__widgets__widget_span$46dart.src__widgets__ticker_provider;
    const animation_controller = packages__flutter__src__animation__animation_controller$46dart.src__animation__animation_controller;
    const tween = packages__flutter__src__animation__listener_helpers$46dart.src__animation__tween;
    const animations = packages__flutter__src__animation__listener_helpers$46dart.src__animation__animations;
    const animation = packages__flutter__src__animation__listener_helpers$46dart.src__animation__animation;
    const curves = packages__flutter__src__animation__curves$46dart.src__animation__curves;
    const box_decoration = packages__flutter__src__painting__box_decoration$46dart.src__painting__box_decoration;
    const colors = packages__flutter__src__material__colors$46dart.src__material__colors;
    const scaffold = packages__flutter__src__material__icon_button$46dart.src__material__scaffold;
    const progress_indicator = packages__flutter__src__material__progress_indicator$46dart.src__material__progress_indicator;
    const provider = packages__cabin__base__provider$46dart.base__provider;
    var splash_page = Object.create(dart.library);
    var $_get = dartx._get;
    var $_set = dartx._set;
    var StringL = () => (StringL = dart.constFn(dart.legacy(core.String)))();
    var LinkedMapOfdynamic$StringL = () => (LinkedMapOfdynamic$StringL = dart.constFn(_js_helper.LinkedMap$(dart.dynamic, StringL())))();
    var doubleL = () => (doubleL = dart.constFn(dart.legacy(core.double)))();
    var TweenOfdoubleL = () => (TweenOfdoubleL = dart.constFn(tween.Tween$(doubleL())))();
    var AlwaysStoppedAnimationOfdoubleL = () => (AlwaysStoppedAnimationOfdoubleL = dart.constFn(animations.AlwaysStoppedAnimation$(doubleL())))();
    var ColorL = () => (ColorL = dart.constFn(dart.legacy(ui.Color)))();
    var AlwaysStoppedAnimationOfColorL = () => (AlwaysStoppedAnimationOfColorL = dart.constFn(animations.AlwaysStoppedAnimation$(ColorL())))();
    var _LocationL = () => (_LocationL = dart.constFn(dart.legacy(widget_inspector._Location)))();
    var ObjectL = () => (ObjectL = dart.constFn(dart.legacy(core.Object)))();
    var intL = () => (intL = dart.constFn(dart.legacy(core.int)))();
    const CT = Object.create(null);
    var L0 = "package:cabin/pages/splash_page.dart";
    dart.defineLazy(CT, {
        get C2() {
            return C2 = dart.const({
                __proto__: widget_inspector._Location.prototype,
                [_Location_parameterLocations]: null,
                [_Location_name]: "valueColor",
                [_Location_column]: 19,
                [_Location_line]: 69,
                [_Location_file]: null
            });
        },
        get C3() {
            return C3 = dart.const({
                __proto__: widget_inspector._Location.prototype,
                [_Location_parameterLocations]: null,
                [_Location_name]: "strokeWidth",
                [_Location_column]: 19,
                [_Location_line]: 70,
                [_Location_file]: null
            });
        },
        get C1() {
            return C1 = dart.constList([C2 || CT.C2, C3 || CT.C3], _LocationL());
        },
        get C0() {
            return C0 = dart.const({
                __proto__: widget_inspector._Location.prototype,
                [_Location_parameterLocations]: C1 || CT.C1,
                [_Location_name]: null,
                [_Location_column]: 28,
                [_Location_line]: 68,
                [_Location_file]: "file:///C:/FlutterDev/cabin/lib/pages/splash_page.dart"
            });
        },
        get C6() {
            return C6 = dart.const({
                __proto__: widget_inspector._Location.prototype,
                [_Location_parameterLocations]: null,
                [_Location_name]: "child",
                [_Location_column]: 21,
                [_Location_line]: 68,
                [_Location_file]: null
            });
        },
        get C5() {
            return C5 = dart.constList([C6 || CT.C6], _LocationL());
        },
        get C4() {
            return C4 = dart.const({
                __proto__: widget_inspector._Location.prototype,
                [_Location_parameterLocations]: C5 || CT.C5,
                [_Location_name]: null,
                [_Location_column]: 24,
                [_Location_line]: 67,
                [_Location_file]: "file:///C:/FlutterDev/cabin/lib/pages/splash_page.dart"
            });
        },
        get C9() {
            return C9 = dart.const({
                __proto__: widget_inspector._Location.prototype,
                [_Location_parameterLocations]: null,
                [_Location_name]: "opacity",
                [_Location_column]: 17,
                [_Location_line]: 66,
                [_Location_file]: null
            });
        },
        get C10() {
            return C10 = dart.const({
                __proto__: widget_inspector._Location.prototype,
                [_Location_parameterLocations]: null,
                [_Location_name]: "child",
                [_Location_column]: 17,
                [_Location_line]: 67,
                [_Location_file]: null
            });
        },
        get C8() {
            return C8 = dart.constList([C9 || CT.C9, C10 || CT.C10], _LocationL());
        },
        get C7() {
            return C7 = dart.const({
                __proto__: widget_inspector._Location.prototype,
                [_Location_parameterLocations]: C8 || CT.C8,
                [_Location_name]: null,
                [_Location_column]: 19,
                [_Location_line]: 65,
                [_Location_file]: "file:///C:/FlutterDev/cabin/lib/pages/splash_page.dart"
            });
        },
        get C13() {
            return C13 = dart.const({
                __proto__: widget_inspector._Location.prototype,
                [_Location_parameterLocations]: null,
                [_Location_name]: "backgroundColor",
                [_Location_column]: 13,
                [_Location_line]: 64,
                [_Location_file]: null
            });
        },
        get C14() {
            return C14 = dart.const({
                __proto__: widget_inspector._Location.prototype,
                [_Location_parameterLocations]: null,
                [_Location_name]: "body",
                [_Location_column]: 13,
                [_Location_line]: 65,
                [_Location_file]: null
            });
        },
        get C12() {
            return C12 = dart.constList([C13 || CT.C13, C14 || CT.C14], _LocationL());
        },
        get C11() {
            return C11 = dart.const({
                __proto__: widget_inspector._Location.prototype,
                [_Location_parameterLocations]: C12 || CT.C12,
                [_Location_name]: null,
                [_Location_column]: 16,
                [_Location_line]: 63,
                [_Location_file]: "file:///C:/FlutterDev/cabin/lib/pages/splash_page.dart"
            });
        },
        get C17() {
            return C17 = dart.const({
                __proto__: widget_inspector._Location.prototype,
                [_Location_parameterLocations]: null,
                [_Location_name]: "decoration",
                [_Location_column]: 9,
                [_Location_line]: 60,
                [_Location_file]: null
            });
        },
        get C18() {
            return C18 = dart.const({
                __proto__: widget_inspector._Location.prototype,
                [_Location_parameterLocations]: null,
                [_Location_name]: "child",
                [_Location_column]: 9,
                [_Location_line]: 63,
                [_Location_file]: null
            });
        },
        get C16() {
            return C16 = dart.constList([C17 || CT.C17, C18 || CT.C18], _LocationL());
        },
        get C15() {
            return C15 = dart.const({
                __proto__: widget_inspector._Location.prototype,
                [_Location_parameterLocations]: C16 || CT.C16,
                [_Location_name]: null,
                [_Location_column]: 12,
                [_Location_line]: 59,
                [_Location_file]: "file:///C:/FlutterDev/cabin/lib/pages/splash_page.dart"
            });
        }
    }, false);
    var outputAndHome = dart.privateName(splash_page, "AnimatedSplash.outputAndHome");
    splash_page.AnimatedSplash = class AnimatedSplash extends framework.StatefulWidget {
        get outputAndHome() {
            return this[outputAndHome];
        }
        set outputAndHome(value) {
            super.outputAndHome = value;
        }
        createState() {
            return new splash_page._AnimatedSplashState.new();
        }
    };
    (splash_page.AnimatedSplash.new = function (opts) {
        let $36creationLocationd_0dea112b090073317d4 = opts && '$creationLocationd_0dea112b090073317d4' in opts ? opts.$creationLocationd_0dea112b090073317d4 : null;
        this[outputAndHome] = new (LinkedMapOfdynamic$StringL()).from([0, "/home"]);
        splash_page.AnimatedSplash.__proto__.new.call(this, { $creationLocationd_0dea112b090073317d4: $36creationLocationd_0dea112b090073317d4 });
    }).prototype = splash_page.AnimatedSplash.prototype;
    dart.addTypeTests(splash_page.AnimatedSplash);
    dart.addTypeCaches(splash_page.AnimatedSplash);
    dart.setMethodSignature(splash_page.AnimatedSplash, () => ({
        __proto__: dart.getMethods(splash_page.AnimatedSplash.__proto__),
        createState: dart.fnType(dart.legacy(splash_page._AnimatedSplashState), [])
    }));
    dart.setLibraryUri(splash_page.AnimatedSplash, L0);
    dart.setFieldSignature(splash_page.AnimatedSplash, () => ({
        __proto__: dart.getFields(splash_page.AnimatedSplash.__proto__),
        outputAndHome: dart.finalFieldType(dart.legacy(core.Map$(dart.dynamic, dart.legacy(core.String))))
    }));
    var _animationController = dart.privateName(splash_page, "_animationController");
    var _animation = dart.privateName(splash_page, "_animation");
    var _Location_parameterLocations = dart.privateName(widget_inspector, "_Location.parameterLocations");
    var _Location_name = dart.privateName(widget_inspector, "_Location.name");
    var _Location_column = dart.privateName(widget_inspector, "_Location.column");
    var _Location_line = dart.privateName(widget_inspector, "_Location.line");
    var _Location_file = dart.privateName(widget_inspector, "_Location.file");
    var C2;
    var C3;
    var C1;
    var C0;
    var C6;
    var C5;
    var C4;
    var C9;
    var C10;
    var C8;
    var C7;
    var C13;
    var C14;
    var C12;
    var C11;
    var C17;
    var C18;
    var C16;
    var C15;
    const State_SingleTickerProviderStateMixin$36 = class State_SingleTickerProviderStateMixin extends framework.State$(dart.legacy(splash_page.AnimatedSplash)) { };
    (State_SingleTickerProviderStateMixin$36.new = function () {
        ticker_provider.SingleTickerProviderStateMixin$(dart.legacy(splash_page.AnimatedSplash))[dart.mixinNew].call(this);
        State_SingleTickerProviderStateMixin$36.__proto__.new.call(this);
    }).prototype = State_SingleTickerProviderStateMixin$36.prototype;
    dart.applyMixin(State_SingleTickerProviderStateMixin$36, ticker_provider.SingleTickerProviderStateMixin$(dart.legacy(splash_page.AnimatedSplash)));
    splash_page._AnimatedSplashState = class _AnimatedSplashState extends State_SingleTickerProviderStateMixin$36 {
        initState() {
            super.initState();
            this[_animationController] = new animation_controller.AnimationController.new({ vsync: this, duration: new core.Duration.new({ milliseconds: 3000 }) });
            this[_animation] = new (TweenOfdoubleL()).new({ begin: 0.0, end: 1.0 }).animate(new animations.CurvedAnimation.new({ parent: this[_animationController], curve: curves.Curves.easeInCirc }));
            this[_animationController].forward();
        }
        dispose() {
            super.dispose();
            this[_animationController].dispose();
        }
        build(context) {
            this.task();
            return new container.Container.new({ decoration: new box_decoration.BoxDecoration.new({ color: colors.Colors.grey._get(200) }), child: new scaffold.Scaffold.new({ backgroundColor: colors.Colors.transparent, body: new transitions.FadeTransition.new({ opacity: new (AlwaysStoppedAnimationOfdoubleL()).new(1.0), child: new basic.Center.new({ child: new progress_indicator.CircularProgressIndicator.new({ valueColor: new (AlwaysStoppedAnimationOfColorL()).new(colors.Colors.brown), strokeWidth: 2.0, $creationLocationd_0dea112b090073317d4: C0 || CT.C0 }), $creationLocationd_0dea112b090073317d4: C4 || CT.C4 }), $creationLocationd_0dea112b090073317d4: C7 || CT.C7 }), $creationLocationd_0dea112b090073317d4: C11 || CT.C11 }), $creationLocationd_0dea112b090073317d4: C15 || CT.C15 });
        }
        task() {
            return async.async(dart.dynamic, (function* task() {
                let value = (yield splash_page.duringSplash());
                yield async.Future.delayed(new core.Duration.new({ milliseconds: 2000 }));
                navigator.Navigator.of(this.context).pushReplacementNamed(ObjectL(), ObjectL(), this.widget.outputAndHome[$_get](value));
            }).bind(this));
        }
    };
    (splash_page._AnimatedSplashState.new = function () {
        this[_animationController] = null;
        this[_animation] = null;
        splash_page._AnimatedSplashState.__proto__.new.call(this);
        ;
    }).prototype = splash_page._AnimatedSplashState.prototype;
    dart.addTypeTests(splash_page._AnimatedSplashState);
    dart.addTypeCaches(splash_page._AnimatedSplashState);
    dart.setMethodSignature(splash_page._AnimatedSplashState, () => ({
        __proto__: dart.getMethods(splash_page._AnimatedSplashState.__proto__),
        build: dart.fnType(dart.legacy(framework.Widget), [dart.legacy(framework.BuildContext)]),
        task: dart.fnType(dart.legacy(async.Future), [])
    }));
    dart.setLibraryUri(splash_page._AnimatedSplashState, L0);
    dart.setFieldSignature(splash_page._AnimatedSplashState, () => ({
        __proto__: dart.getFields(splash_page._AnimatedSplashState.__proto__),
        [_animationController]: dart.fieldType(dart.legacy(animation_controller.AnimationController)),
        [_animation]: dart.fieldType(dart.legacy(animation.Animation))
    }));
    splash_page.duringSplash = function duringSplash() {
        return async.async(intL(), function* duringSplash() {
            let param = new _js_helper.LinkedMap.new();
            let userType = 0;
            try {
                param[$_set]("id", yield provider.LocalData.obtainValue("id"));
                param[$_set]("password", yield provider.LocalData.obtainValue("password"));
            } catch (e) {
                let erorr = dart.getThrown(e);
                return 0;
            }
            return userType;
        });
    };
    dart.trackLibraries("packages/cabin/pages/splash_page.dart", {
        "package:cabin/pages/splash_page.dart": splash_page
    }, {
    }, '{"version":3,"sourceRoot":"","sources":["splash_page.dart"],"names":[],"mappings":";;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;IAuB6B;;;;;;;AAQW;IAAsB;;;;IARjC,sBAAgB,yCACzC,GAAG;AAIL;EAAkB;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;AAaC,MAAX;AAEkD,MADxD,6BAA2B,yDAChB,gBAAgB,qCAAuB;AAEU,MAD5D,mBAAa,AAA4B,mCAAf,UAAU,cAAa,4CACrC,mCAAoC;AAClB,MAA9B,AAAqB;IACvB;;AAIiB,MAAT;AACwB,MAA9B,AAAqB;IACvB;UAG0B;AAClB,MAAN;AACA,YAAO,0CACS,6CACI,AAAI,wBAAC,eAEd,4CACqB,iCAClB,6CACO,4CAA+B,aACjC,6BACI,kEACO,2CAAqC,mCACxC;IAE7B;;AAEW;AACL,qBAAQ,MAAM;AACgC,QAAlD,MAAa,qBAAQ,qCAAuB;AAC2B,QAA7D,AAAY,uBAAT,yDAA8B,AAAO,AAAa,iCAAC,KAAK;MACvE;;;;IAzCoB;IACV;;;EAyCZ;;;;;;;;;;;;;;;AAzEwB;AAClB,kBAAQ;AACR,qBAAW;AACf;AACiD,QAA/C,AAAK,KAAA,QAAC,MAAQ,MAAgB,+BAAY;AACiB,QAA3D,AAAK,KAAA,QAAC,YAAc,MAAgB,+BAAY;;YAIzC;AACP,cAAO;;AAET,YAAO,SAAQ;IACjB","file":"../../../../packages/cabin/pages/splash_page.dart.lib.js"}');
    // Exports:
    return {
        pages__splash_page: splash_page
    };
});

//# sourceMappingURL=splash_page.dart.lib.js.map