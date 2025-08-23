import 'package:example/page/my_button_page.dart';
import 'package:flutter/material.dart';

import 'base/example_base.dart';
import 'page/sidebar/td_sidebar_page.dart';
import 'page/sidebar/td_sidebar_page_anchor.dart';
import 'page/sidebar/td_sidebar_page_custom.dart';
import 'page/sidebar/td_sidebar_page_icon.dart';
import 'page/sidebar/td_sidebar_page_loading.dart';
import 'page/sidebar/td_sidebar_page_outline.dart';
import 'page/sidebar/td_sidebar_page_pagination.dart';
import 'page/td_action_sheet_page.dart';
import 'page/td_avatar_page.dart';
import 'page/td_backtop_page.dart';
import 'page/td_badge_page.dart';
import 'page/td_bottom_tab_bar_page.dart';
import 'page/td_calendar_page.dart';
import 'page/td_cascader_page.dart';
import 'page/td_cell_page.dart';
import 'page/td_checkbox_page.dart';
import 'page/td_collapse.dart';
import 'page/td_date_picker_page.dart';
import 'page/td_dialog_page.dart';
import 'page/my_divider_page.dart';
import 'page/td_drawer_page.dart';
import 'page/td_dropdown_menu_page.dart';
import 'page/td_empty_page.dart';
import 'page/td_fab_page.dart';
import 'page/td_font_page.dart';
import 'page/td_footer_page.dart';
import 'page/td_icon_page.dart';
import 'page/td_image_page.dart';
import 'page/td_image_viewer_page.dart';
import 'page/td_indexes_page.dart';
import 'page/td_input_page.dart';
import 'page/my_link_page.dart';
import 'page/td_loading_page.dart';
import 'page/td_message_page.dart';
import 'page/td_navbar_page.dart';
import 'page/td_notice_bar_page.dart';
import 'page/td_picker_page.dart';
import 'page/td_popover_page.dart';
import 'page/td_popup_page.dart';
import 'page/td_progress_page.dart';
import 'page/td_radio_page.dart';
import 'page/td_radius_page.dart';
import 'page/td_rate_page.dart';
import 'page/td_refresh_page.dart';
import 'page/td_result_page.dart';
import 'page/td_search_bar_page.dart';
import 'page/td_shadows_page.dart';
import 'page/td_skeleton_page.dart';
import 'page/td_slider_page.dart';
import 'page/td_stepper_page.dart';
import 'page/td_steps_page.dart';
import 'page/td_swipe_cell_page.dart';
import 'page/td_steps_page.dart';
import 'page/td_swiper_page.dart';
import 'page/td_switch_page.dart';
import 'page/td_table_page.dart';
import 'page/td_tabs_page.dart';
import 'page/td_tag_page.dart';
import 'page/my_text_page.dart';
import 'page/td_textarea_page.dart';
import 'page/td_theme_page.dart';
import 'page/td_time_counter_page.dart';
import 'page/td_toast_page.dart';
import 'page/td_tree_select_page.dart';
import 'page/td_upload_page.dart';
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
    ExamplePageModel(
      text: 'Fab',
      name: 'fab',
      pageBuilder: _wrapInheritedTheme((context) => const TDFabPage()),
    ),
    ExamplePageModel(
      text: 'Icon',
      name: 'icon',
      pageBuilder: _wrapInheritedTheme((context) => const TDIconPage()),
    ),
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
      pageBuilder: _wrapInheritedTheme((context) => const TDBackTopPage()),
    ),
    ExamplePageModel(
      text: 'Drawer',
      name: 'drawer',
      pageBuilder: _wrapInheritedTheme((context) => const TDDrawerPage()),
    ),
    ExamplePageModel(
      text: 'Indexes',
      name: 'indexes',
      pageBuilder: _wrapInheritedTheme((context) => const TDIndexesPage()),
    ),
    ExamplePageModel(
      text: 'NavBar',
      name: 'navbar',
      pageBuilder: _wrapInheritedTheme((context) => const TDNavBarPage()),
    ),
    ExamplePageModel(
      text: 'SideBar',
      name: 'side-bar',
      pageBuilder: _wrapInheritedTheme((context) => const TDSideBarPage()),
    ),
    ExamplePageModel(
      text: 'Steps',
      name: 'steps',
      pageBuilder: _wrapInheritedTheme((context) => const TDStepsPage()),
    ),
    ExamplePageModel(
      text: 'TabBar',
      name: 'tab-bar',
      pageName: 'bottom_tab_bar',
      pageBuilder: _wrapInheritedTheme((context) => const TDBottomTabBarPage()),
    ),
    ExamplePageModel(
      text: 'Tabs',
      name: 'tabs',
      pageBuilder: _wrapInheritedTheme((context) => const TDTabsPage()),
    ),
  ],
  'Input': [
    ExamplePageModel(
      text: 'Calendar',
      name: 'calendar',
      pageBuilder: _wrapInheritedTheme((context) => const TDCalendarPage()),
    ),
    ExamplePageModel(
      text: 'Cascader',
      name: 'cascader',
      pageBuilder: _wrapInheritedTheme((context) => const TDCascaderPage()),
    ),
    ExamplePageModel(
      text: 'Checkbox',
      name: 'checkbox',
      pageBuilder: _wrapInheritedTheme((context) => const TDCheckboxPage()),
    ),
    ExamplePageModel(
      text: 'DateTimePicker',
      name: 'date-time-picker',
      pageName: 'data_picker',
      pageBuilder: _wrapInheritedTheme((context) => const TDDatePickerPage()),
    ),
    ExamplePageModel(
      text: 'Input',
      name: 'input',
      pageBuilder: _wrapInheritedTheme((context) => const TDInputViewPage()),
    ),
    ExamplePageModel(
      text: 'Picker',
      name: 'picker',
      pageBuilder: _wrapInheritedTheme((context) => const TDPickerPage()),
    ),
    ExamplePageModel(
      text: 'Radio',
      name: 'radio',
      pageBuilder: _wrapInheritedTheme((context) => const TDRadioPage()),
    ),
    ExamplePageModel(
      text: 'Rate',
      name: 'rate',
      pageBuilder: _wrapInheritedTheme((context) => const TDRatePage()),
    ),
    ExamplePageModel(
      text: 'Search',
      name: 'search',
      pageBuilder: _wrapInheritedTheme((context) => const TDSearchBarPage()),
    ),
    ExamplePageModel(
      text: 'Slider',
      name: 'slider',
      pageBuilder: _wrapInheritedTheme((context) => const TDSliderPage()),
    ),
    ExamplePageModel(
      text: 'Stepper',
      name: 'stepper',
      pageBuilder: _wrapInheritedTheme((context) => const TDStepperPage()),
    ),
    ExamplePageModel(
      text: 'Switch',
      name: 'switch',
      pageBuilder: _wrapInheritedTheme((context) => const TDSwitchPage()),
    ),
    ExamplePageModel(
      text: 'Textarea',
      name: 'textarea',
      pageBuilder: _wrapInheritedTheme((context) => const TDTextareaPage()),
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
      pageBuilder: _wrapInheritedTheme((context) => const TDUploadPage()),
    ),
  ],
  'Data display': [
    ExamplePageModel(
      text: 'Avatar',
      name: 'avatar',
      pageBuilder: _wrapInheritedTheme((context) => const TDAvatarPage()),
    ),
    ExamplePageModel(
      text: 'Badge',
      name: 'badge',
      pageBuilder: _wrapInheritedTheme((context) => const TDBadgePage()),
    ),
    ExamplePageModel(
      text: 'Cell',
      name: 'cell',
      pageBuilder: _wrapInheritedTheme((context) => const TDCellPage()),
    ),
    ExamplePageModel(
      text: 'TimeCounter',
      name: 'time-counter',
      pageBuilder: _wrapInheritedTheme((context) => const TDTimeCounterPage()),
    ),
    ExamplePageModel(
      text: 'Collapse',
      name: 'collapse',
      pageBuilder: _wrapInheritedTheme((context) => const TDCollapsePage()),
    ),
    ExamplePageModel(
      text: 'Empty',
      name: 'empty',
      pageBuilder: _wrapInheritedTheme((context) => const TDEmptyPage()),
    ),
    ExamplePageModel(
      text: 'Footer',
      name: 'footer',
      pageBuilder: _wrapInheritedTheme((context) => const TDFooterPage()),
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
      pageBuilder: _wrapInheritedTheme((context) => const TDImagePage()),
    ),
    ExamplePageModel(
      text: 'ImageViewer',
      name: 'image-viewer',
      pageName: 'image_viewer',
      pageBuilder: _wrapInheritedTheme((context) => const TDImageViewerPage()),
    ),
    ExamplePageModel(
      text: 'Progress',
      name: 'progress',
      pageBuilder: _wrapInheritedTheme((context) => const TDProgressPage()),
    ),
    ExamplePageModel(
      text: 'Result',
      name: 'result',
      pageBuilder: _wrapInheritedTheme((context) => const TDResultPage()),
    ),
    ExamplePageModel(
      text: 'Skeleton',
      name: 'skeleton',
      pageBuilder: _wrapInheritedTheme((context) => const TDSkeletonPage()),
    ),
    ExamplePageModel(
      text: 'Sticky 吸顶',
      name: 'sticky',
      isTodo: true,
      pageBuilder: _wrapInheritedTheme((context) => const TodoPage()),
    ),
    ExamplePageModel(
      text: 'Swiper',
      name: 'swiper',
      pageBuilder: _wrapInheritedTheme((context) => const TDSwiperPage()),
    ),
    ExamplePageModel(
      text: 'Table',
      name: 'table',
      pageBuilder: _wrapInheritedTheme((context) => const TDTablePage()),
    ),
    ExamplePageModel(
      text: 'Tag',
      name: 'tag',
      pageBuilder: _wrapInheritedTheme((context) => const TDTagPage()),
    ),
  ],
  'Feedback': [
    ExamplePageModel(
      text: 'ActionSheet',
      name: 'action-sheet',
      pageName: 'action_sheet',
      pageBuilder: _wrapInheritedTheme((context) => const TDActionSheetPage()),
    ),
    ExamplePageModel(
      text: 'Dialog',
      name: 'dialog',
      pageBuilder: _wrapInheritedTheme((context) => const TDDialogPage()),
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
      pageBuilder: _wrapInheritedTheme((context) => const TDLoadingPage()),
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
      (context) => const TDSideBarPaginationPage(),
    ),
  ),
  ExamplePageModel(
    text: 'SideBar Anchor',
    name: 'SideBarAnchor',
    isTodo: false,
    pageBuilder: _wrapInheritedTheme((context) => const TDSideBarAnchorPage()),
  ),
  ExamplePageModel(
    text: 'SideBar Icon',
    name: 'SideBarIcon',
    isTodo: false,
    pageBuilder: _wrapInheritedTheme((context) => const TDSideBarIconPage()),
  ),
  ExamplePageModel(
    text: 'SideBar Oultine',
    name: 'SideBarOutline',
    isTodo: false,
    pageBuilder: _wrapInheritedTheme((context) => const TDSideBarOutlinePage()),
  ),
  ExamplePageModel(
    text: 'SideBar Custom',
    name: 'SideBarCustom',
    isTodo: false,
    pageBuilder: _wrapInheritedTheme((context) => const TDSideBarCustomPage()),
  ),
  ExamplePageModel(
    text: 'SideBar Loading',
    name: 'SideBarLoading',
    isTodo: false,
    pageBuilder: _wrapInheritedTheme((context) => const TDSideBarLoadingPage()),
  ),
];
