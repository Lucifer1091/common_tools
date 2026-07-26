import 'package:flutter/material.dart';
import 'package:example/common_tools_catalog.dart';

import '../../base/example_widget.dart';

class MySwiperPage extends StatelessWidget {
  const MySwiperPage({super.key});

  static const images = [
    'https://images.pexels.com/photos/842711/pexels-photo-842711.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
    'https://fastly.picsum.photos/id/10/2500/1667.jpg?hmac=J04WWC_ebchx3WwzbM-Z4_KC_LeLBWr5LZMaAkWkF68',
    'https://fastly.picsum.photos/id/11/2500/1667.jpg?hmac=xxjFJtAPgshYkysU_aqx2sZir-kIOjNR9vx0te7GycQ',
    'https://fastly.picsum.photos/id/12/2500/1667.jpg?hmac=Pe3284luVre9ZqNzv1jMFpLihFI6lwq7TPgMSsNXw2w',
    'https://fastly.picsum.photos/id/13/2500/1667.jpg?hmac=SoX9UoHhN8HyklRA4A3vcCWJMVtiBXUg0W4ljWTor7s',
    'https://fastly.picsum.photos/id/14/2500/1667.jpg?hmac=ssQyTcZRRumHXVbQAVlXTx-MGBxm6NHWD3SryQ48G-o',
  ];

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: myTitle(context),
      exampleCodeGroup: 'swiper',
      desc:
          'A carousel widget displays multiple content items (images, text, videos, etc.) in a single, compact space, allowing users to swipe or click through them horizontally or vertically.',
      children: [
        ExampleModule(
          title: 'Component Types',
          children: [
            ExampleItem(desc: 'Dots', builder: _buildDotsSwiper),
            ExampleItem(desc: 'Dots bar', builder: _buildDotsBarSwiper),
            ExampleItem(desc: 'Fraction', builder: _buildFractionSwiper),
            ExampleItem(desc: 'Controls', builder: _buildControlsSwiper),
            ExampleItem(desc: 'Cards', builder: _buildCardsSwiper),
            ExampleItem(
              desc: 'Cards - Scale: 0.8',
              builder: _buildScaleCardsSwiper,
            ),
          ],
        ),
        ExampleModule(
          title: 'Component Style',
          children: [
            ExampleItem(desc: 'Internal', builder: _buildDotsSwiper),
            ExampleItem(desc: 'External', builder: _buildOuterDotsSwiper),
            ExampleItem(
              desc: 'Right Side (Vertical)',
              builder: _buildRightDotsSwiper,
            ),
          ],
        ),
      ],

      test: [
        ExampleItem(
          desc: "Cards, only two cards that don't rotate.",
          builder: _buildNotLoopCardsSwiper,
        ),
        ExampleItem(
          desc: 'Partition character position',
          builder: _buildFractionBarSwiper,
        ),
        ExampleItem(
          desc: 'Vertical Dotter Bar',
          builder: _buildVerticalDotsBarSwiper,
        ),
      ],
    );
  }

  Widget _wrapper(Widget child) {
    return Container(
      height: 193,
      margin: const EdgeInsets.only(left: 16, right: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(MyRadius.large),
      ),
      child: child,
    );
  }

  Widget builder(BuildContext context, int index) {
    return MyImage(
      source: images[index],
      width: double.maxFinite,
      height: double.maxFinite,
    );
  }

  Widget _buildDotsSwiper(BuildContext context) {
    return _wrapper(
      MySwiper(
        loop: true,
        autoplay: true,
        itemCount: 6,
        pagination: const SwiperPagination(builder: MySwiperPagination.dots),
        itemBuilder: builder,
      ),
    );
  }

  Widget _buildDotsBarSwiper(BuildContext context) {
    return _wrapper(
      MySwiper(
        loop: true,
        autoplay: true,
        itemCount: 6,
        pagination: const SwiperPagination(
          alignment: Alignment.bottomCenter,
          builder: MySwiperPagination.dotsBar,
        ),
        itemBuilder: builder,
      ),
    );
  }

  Widget _buildFractionSwiper(BuildContext context) {
    return _wrapper(
      MySwiper(
        loop: true,
        autoplay: true,
        itemCount: 6,
        pagination: const SwiperPagination(
          alignment: Alignment.bottomCenter,
          builder: MySwiperPagination.fraction,
        ),
        itemBuilder: builder,
      ),
    );
  }

  Widget _buildControlsSwiper(BuildContext context) {
    return _wrapper(
      MySwiper(
        loop: true,
        itemCount: 6,
        pagination: const SwiperPagination(
          alignment: Alignment.center,
          builder: MySwiperPagination.controls,
        ),
        itemBuilder: builder,
      ),
    );
  }

  Widget _buildCardsSwiper(BuildContext context) {
    return _wrapper(
      MySwiper(
        loop: true,
        outer: true,
        autoplay: true,
        itemCount: 6,
        viewportFraction: 0.75,
        transformer: MyPageTransformer.margin(),
        pagination: const SwiperPagination(
          alignment: Alignment.center,
          builder: MySwiperPagination.dots,
        ),
        itemBuilder: builder,
      ),
    );
  }

  Widget _buildScaleCardsSwiper(BuildContext context) {
    return _wrapper(
      MySwiper(
        loop: true,
        outer: true,
        autoplay: true,
        itemCount: 6,
        viewportFraction: 0.75,
        transformer: MyPageTransformer.scaleAndFade(),
        pagination: const SwiperPagination(
          alignment: Alignment.center,
          builder: MySwiperPagination.dots,
        ),
        itemBuilder: builder,
      ),
    );
  }

  Widget _buildOuterDotsSwiper(BuildContext context) {
    return _wrapper(
      MySwiper(
        autoplay: true,
        itemCount: 6,
        loop: true,
        outer: true,
        pagination: const SwiperPagination(
          alignment: Alignment.bottomCenter,
          builder: MySwiperPagination.dotsBar,
        ),
        itemBuilder: builder,
      ),
    );
  }

  Widget _buildRightDotsSwiper(BuildContext context) {
    return _wrapper(
      MySwiper(
        autoplay: true,
        itemCount: 6,
        loop: true,
        scrollDirection: Axis.vertical,
        pagination: const SwiperPagination(
          alignment: Alignment.centerRight,
          builder: MySwiperPagination.dots,
        ),
        itemBuilder: builder,
      ),
    );
  }

  Widget _buildNotLoopCardsSwiper(BuildContext context) {
    return _wrapper(
      MySwiper(
        viewportFraction: 0.75,
        scale: 0.8,
        outer: true,
        autoplay: true,
        itemCount: 2,
        loop: false,
        pagination: const SwiperPagination(
          alignment: Alignment.center,
          builder: MySwiperPagination.dots,
        ),
        itemBuilder: builder,
      ),
    );
  }

  Widget _buildFractionBarSwiper(BuildContext context) {
    return _wrapper(
      MySwiper(
        autoplay: true,
        itemCount: 6,
        loop: true,
        pagination: const SwiperPagination(
          alignment: Alignment.bottomRight,
          builder: MySwiperPagination.fraction,
        ),
        itemBuilder: builder,
      ),
    );
  }

  Widget _buildVerticalDotsBarSwiper(BuildContext context) {
    return _wrapper(
      MySwiper(
        autoplay: true,
        itemCount: 6,
        loop: true,
        scrollDirection: Axis.vertical,
        pagination: const SwiperPagination(
          alignment: Alignment.bottomRight,
          builder: MySwiperPagination.dotsBar,
        ),
        itemBuilder: builder,
      ),
    );
  }
}
