import 'package:example/page/my_backtop_page.dart';
import 'package:example/page/my_button_page.dart';
import 'package:example/page/my_steps_page.dart';
import 'package:flutter/material.dart';

import 'base/example_base.dart';
import 'page/my_otp_page.dart';
import 'page/sidebar/my_sidebar_page.dart';
import 'page/sidebar/my_sidebar_page_anchor.dart';
import 'page/sidebar/my_sidebar_page_custom.dart';
import 'page/sidebar/my_sidebar_page_icon.dart';
import 'page/sidebar/my_sidebar_page_loading.dart';
import 'page/sidebar/my_sidebar_page_outline.dart';
import 'page/sidebar/my_sidebar_page_pagination.dart';
import 'page/my_action_sheet_page.dart';
import 'page/my_avatar_page.dart';
import 'page/my_badge_page.dart';
import 'page/my_cell_page.dart';
import 'page/my_checkbox_page.dart';
import 'page/my_collapse_page.dart';
import 'page/my_date_picker_page.dart';
import 'page/my_dialog_page.dart';
import 'page/my_divider_page.dart';
import 'page/my_drawer_page.dart';
import 'page/td_dropdown_menu_page.dart';
import 'page/my_errors_page.dart';
import 'page/td_font_page.dart';
import 'page/my_footer_page.dart';
import 'page/my_image_page.dart';
import 'page/my_image_viewer_page.dart';
import 'page/my_indexes_page.dart';
import 'page/my_input_page.dart';
import 'page/my_link_page.dart';
import 'page/my_loader_page.dart';
import 'page/td_message_page.dart';
import 'page/td_navbar_page.dart';
import 'page/td_notice_bar_page.dart';
import 'page/my_picker_page.dart';
import 'page/td_popover_page.dart';
import 'page/td_popup_page.dart';
import 'page/my_progress_page.dart';
import 'page/my_radio_page.dart';
import 'page/td_radius_page.dart';
import 'page/my_rating_page.dart';
import 'page/td_refresh_page.dart';
import 'page/my_result_page.dart';
import 'page/td_search_bar_page.dart';
import 'page/td_shadows_page.dart';
import 'page/my_skeleton_page.dart';
import 'page/my_slider_page.dart';
import 'page/my_stepper_page.dart';
import 'page/td_swipe_cell_page.dart';
import 'page/my_swiper_page.dart';
import 'page/my_switch_page.dart';
import 'page/my_table_page.dart';
import 'page/my_tabs_page.dart';
import 'page/my_tag_page.dart';
import 'page/my_text_page.dart';
import 'page/my_textarea_page.dart';
import 'page/td_theme_page.dart';
import 'page/my_time_counter_page.dart';
import 'page/td_toast_page.dart';
import 'page/td_tree_select_page.dart';
import 'page/my_upload_page.dart';
import 'page/todo_page.dart';

PageBuilder _wrapInheritedTheme(WidgetBuilder builder) {
  return (context, model) {
    return ExamplePageInheritedTheme(model: model, child: builder(context));
  };
}

/// New sample page, just add the model here, and the add button will be
/// automatically registered. For sample page writing, refer to TDTextPage()
List<ExamplePageModel> examplePageList = [];

Map<String, List<ExamplePageModel>> exampleMap = {
  'Base': [
    ExamplePageModel(
      text: 'Button',
      name: 'button',
      pageBuilder: _wrapInheritedTheme((context) => const MyButtonPage()),
    ),
    ExamplePageModel(
      text: 'Divider',
      name: 'divider',
      pageBuilder: _wrapInheritedTheme((context) => const MyDividerPage()),
    ),
    // ExamplePageModel(
    //   text: 'Fab',
    //   name: 'fab',
    //   pageBuilder: _wrapInheritedTheme((context) => const TDFabPage()),
    // ),
    // ExamplePageModel(
    //   text: 'Icon',
    //   name: 'icon',
    //   pageBuilder: _wrapInheritedTheme((context) => const TDIconPage()),
    // ),
    ExamplePageModel(
      text: 'Link',
      name: 'link',
      pageBuilder: _wrapInheritedTheme((context) => const MyLinkPage()),
    ),
    ExamplePageModel(
      text: 'Text',
      name: 'text',
      pageBuilder: _wrapInheritedTheme((context) => const MyTextPage()),
    ),
  ],
  'Navigation': [
    ExamplePageModel(
      text: 'BackTop',
      name: 'back-top',
      pageName: 'backtop',
      pageBuilder: _wrapInheritedTheme((context) => const MyBackTopPage()),
    ),
    ExamplePageModel(
      text: 'Drawer',
      name: 'drawer',
      pageBuilder: _wrapInheritedTheme((context) => const MyDrawerPage()),
    ),
    ExamplePageModel(
      text: 'Indexes',
      name: 'indexes',
      pageBuilder: _wrapInheritedTheme((context) => const MyIndexesPage()),
    ),
    ExamplePageModel(
      text: 'NavBar',
      name: 'navbar',
      pageBuilder: _wrapInheritedTheme((context) => const MyNavBarPage()),
    ),
    ExamplePageModel(
      text: 'SideBar',
      name: 'side-bar',
      pageBuilder: _wrapInheritedTheme((context) => const MySideBarPage()),
    ),
    ExamplePageModel(
      text: 'Steps',
      name: 'steps',
      pageBuilder: _wrapInheritedTheme((context) => const MyStepsPage()),
    ),
    // ExamplePageModel(
    //   text: 'TabBar',
    //   name: 'tab-bar',
    //   pageName: 'bottom_tab_bar',
    //   pageBuilder: _wrapInheritedTheme((context) => const MyBottomTabBarPage()),
    // ),
    ExamplePageModel(
      text: 'TabBar',
      name: 'tabs',
      pageBuilder: _wrapInheritedTheme((context) => const MyTabsPage()),
    ),
  ],
  'Input': [
    // ExamplePageModel(
    //   text: 'Calendar',
    //   name: 'calendar',
    //   pageBuilder: _wrapInheritedTheme((context) => const TDCalendarPage()),
    // ),
    // ExamplePageModel(
    //   text: 'Cascader',
    //   name: 'cascader',
    //   pageBuilder: _wrapInheritedTheme((context) => const TDCascaderPage()),
    // ),
    ExamplePageModel(
      text: 'Checkbox',
      name: 'checkbox',
      pageBuilder: _wrapInheritedTheme((context) => const MyCheckboxPage()),
    ),
    ExamplePageModel(
      text: 'Date & Time Picker',
      name: 'date-time-picker',
      pageName: 'data_picker',
      pageBuilder: _wrapInheritedTheme((context) => const MyDatePickerPage()),
    ),
    ExamplePageModel(
      text: 'Input',
      name: 'input',
      pageBuilder: _wrapInheritedTheme((context) => const MyInputViewPage()),
    ),
    ExamplePageModel(
      text: 'One Time Pass - OTP',
      name: 'otp',
      pageBuilder: _wrapInheritedTheme((context) => const MyOtpPage()),
    ),
    ExamplePageModel(
      text: 'Picker',
      name: 'picker',
      pageBuilder: _wrapInheritedTheme((context) => const MyPickerPage()),
    ),
    ExamplePageModel(
      text: 'Radio',
      name: 'radio',
      pageBuilder: _wrapInheritedTheme((context) => const MyRadioPage()),
    ),
    ExamplePageModel(
      text: 'Rate',
      name: 'rate',
      pageBuilder: _wrapInheritedTheme((context) => const MyRatingBarPage()),
    ),
    ExamplePageModel(
      text: 'Search',
      name: 'search',
      pageBuilder: _wrapInheritedTheme((context) => const TDSearchBarPage()),
    ),
    ExamplePageModel(
      text: 'Slider',
      name: 'slider',
      pageBuilder: _wrapInheritedTheme((context) => const MySliderPage()),
    ),
    ExamplePageModel(
      text: 'Stepper',
      name: 'stepper',
      pageBuilder: _wrapInheritedTheme((context) => const MyStepperPage()),
    ),
    ExamplePageModel(
      text: 'Switch',
      name: 'switch',
      pageBuilder: _wrapInheritedTheme((context) => const MySwitchPage()),
    ),
    ExamplePageModel(
      text: 'Textarea',
      name: 'textarea',
      pageBuilder: _wrapInheritedTheme((context) => const MyTextareaPage()),
    ),
    ExamplePageModel(
      text: 'TreeSelect',
      name: 'tree-select',
      pageName: 'tree_select',
      pageBuilder: _wrapInheritedTheme((context) => const TDTreeSelectPage()),
    ),
    ExamplePageModel(
      text: 'Upload',
      name: 'upload',
      pageBuilder: _wrapInheritedTheme((context) => const MyUploadPage()),
    ),
  ],
  'Data display': [
    ExamplePageModel(
      text: 'Avatar',
      name: 'avatar',
      pageBuilder: _wrapInheritedTheme((context) => const MyAvatarPage()),
    ),
    ExamplePageModel(
      text: 'Badge',
      name: 'badge',
      pageBuilder: _wrapInheritedTheme((context) => const MyBadgePage()),
    ),
    ExamplePageModel(
      text: 'Cell',
      name: 'cell',
      pageBuilder: _wrapInheritedTheme((context) => const MyCellPage()),
    ),
    ExamplePageModel(
      text: 'Time Counter',
      name: 'time-counter',
      pageBuilder: _wrapInheritedTheme((context) => const MyTimeCounterPage()),
    ),
    ExamplePageModel(
      text: 'Collapse',
      name: 'collapse',
      pageBuilder: _wrapInheritedTheme((context) => const MyCollapsePage()),
    ),
    ExamplePageModel(
      text: 'Errors',
      name: 'errors',
      pageBuilder: _wrapInheritedTheme((context) => const MyErrorsPage()),
    ),
    ExamplePageModel(
      text: 'Footer',
      name: 'footer',
      pageBuilder: _wrapInheritedTheme((context) => const MyFooterPage()),
    ),
    ExamplePageModel(
      text: 'Grid',
      name: 'grid',
      isTodo: true,
      pageBuilder: _wrapInheritedTheme((context) => const TodoPage()),
    ),
    ExamplePageModel(
      text: 'Image',
      name: 'image',
      pageBuilder: _wrapInheritedTheme((context) => const MyImagePage()),
    ),
    ExamplePageModel(
      text: 'Image Viewer',
      name: 'image-viewer',
      pageName: 'image_viewer',
      pageBuilder: _wrapInheritedTheme((context) => const MyImageViewerPage()),
    ),
    ExamplePageModel(
      text: 'Progress',
      name: 'progress',
      pageBuilder: _wrapInheritedTheme((context) => const MyProgressPage()),
    ),
    ExamplePageModel(
      text: 'Result',
      name: 'result',
      pageBuilder: _wrapInheritedTheme((context) => const MyResultPage()),
    ),
    ExamplePageModel(
      text: 'Skeleton',
      name: 'skeleton',
      pageBuilder: _wrapInheritedTheme((context) => const MySkeletonPage()),
    ),
    ExamplePageModel(
      text: 'Sticky Header',
      name: 'sticky',
      isTodo: true,
      pageBuilder: _wrapInheritedTheme((context) => const TodoPage()),
    ),
    ExamplePageModel(
      text: 'Swiper',
      name: 'swiper',
      pageBuilder: _wrapInheritedTheme((context) => const MySwiperPage()),
    ),
    ExamplePageModel(
      text: 'Table',
      name: 'table',
      pageBuilder: _wrapInheritedTheme((context) => const MyTablePage()),
    ),
    ExamplePageModel(
      text: 'Tag',
      name: 'tag',
      pageBuilder: _wrapInheritedTheme((context) => const MyTagPage()),
    ),
  ],
  'Feedback': [
    ExamplePageModel(
      text: 'Action Sheet',
      name: 'action-sheet',
      pageName: 'action_sheet',
      pageBuilder: _wrapInheritedTheme((context) => const MyActionSheetPage()),
    ),
    ExamplePageModel(
      text: 'Dialog',
      name: 'dialog',
      pageBuilder: _wrapInheritedTheme((context) => const MyDialogPage()),
    ),
    ExamplePageModel(
      text: 'DropdownMenu',
      name: 'dropdown-menu',
      pageName: 'dropdown_menu',
      pageBuilder: _wrapInheritedTheme((context) => const TDDropdownMenuPage()),
    ),
    ExamplePageModel(
      text: 'Loading',
      name: 'loading',
      pageBuilder: _wrapInheritedTheme((context) => const MyLoaderPage()),
    ),
    ExamplePageModel(
      text: 'Message',
      name: 'message',
      pageBuilder: _wrapInheritedTheme((context) => const TDMessagePage()),
    ),
    ExamplePageModel(
      text: 'NoticeBar',
      name: 'notice-bar',
      pageBuilder: _wrapInheritedTheme((context) => const TDNoticeBarPage()),
    ),
    ExamplePageModel(
      text: 'Overlay',
      name: 'overlay',
      isTodo: true,
      pageBuilder: _wrapInheritedTheme((context) => const TodoPage()),
    ),
    ExamplePageModel(
      text: 'Popover',
      name: 'popover',
      pageBuilder: _wrapInheritedTheme((context) => const TDPopoverPage()),
    ),
    ExamplePageModel(
      text: 'Popup',
      name: 'popup',
      pageBuilder: _wrapInheritedTheme((context) => const TDPopupPage()),
    ),
    ExamplePageModel(
      text: 'PullDownRefresh',
      name: 'pull-down-refresh',
      pageName: 'refresh',
      pageBuilder: _wrapInheritedTheme(
        (context) => const TdPullDownRefreshPage(),
      ),
    ),
    ExamplePageModel(
      text: 'Swipecell',
      name: 'swipe-cell',
      pageName: 'swipe_cell',
      pageBuilder: _wrapInheritedTheme((context) => const TDSwipeCellPage()),
    ),
    ExamplePageModel(
      text: 'Toast',
      name: 'toast',
      pageBuilder: _wrapInheritedTheme((context) => const TDToastPage()),
    ),
  ],
  'Theme': [
    ExamplePageModel(
      text: 'Colors',
      name: 'theme_colors',
      pageBuilder: _wrapInheritedTheme((context) => const TDThemeColorsPage()),
    ),
    ExamplePageModel(
      text: 'Fonts',
      name: 'font',
      pageBuilder: _wrapInheritedTheme((context) => const TDFontPage()),
    ),
    ExamplePageModel(
      text: 'Radius',
      name: 'radius',
      pageBuilder: _wrapInheritedTheme((context) => const TDRadiusPage()),
    ),
    ExamplePageModel(
      text: 'Shadows',
      name: 'shadows',
      pageBuilder: _wrapInheritedTheme((context) => const TDShadowsPage()),
    ),
  ],
};

List<ExamplePageModel> sideBarExamplePage = [
  ExamplePageModel(
    text: 'SideBar',
    name: 'SideBarPagination',
    isTodo: false,
    showAction: false,
    pageBuilder: _wrapInheritedTheme(
      (context) => const MySideBarPaginationPage(),
    ),
  ),
  ExamplePageModel(
    text: 'SideBar Anchor',
    name: 'SideBarAnchor',
    isTodo: false,
    pageBuilder: _wrapInheritedTheme((context) => const MySideBarAnchorPage()),
  ),
  ExamplePageModel(
    text: 'SideBar Icon',
    name: 'SideBarIcon',
    isTodo: false,
    pageBuilder: _wrapInheritedTheme((context) => const MySideBarIconPage()),
  ),
  ExamplePageModel(
    text: 'SideBar Oultine',
    name: 'SideBarOutline',
    isTodo: false,
    pageBuilder: _wrapInheritedTheme((context) => const MySideBarOutlinePage()),
  ),
  ExamplePageModel(
    text: 'SideBar Custom',
    name: 'SideBarCustom',
    isTodo: false,
    pageBuilder: _wrapInheritedTheme((context) => const MySideBarCustomPage()),
  ),
  ExamplePageModel(
    text: 'SideBar Loading',
    name: 'SideBarLoading',
    isTodo: false,
    pageBuilder: _wrapInheritedTheme((context) => const MySideBarLoadingPage()),
  ),
];
