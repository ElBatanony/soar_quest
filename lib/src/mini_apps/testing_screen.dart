import 'package:flutter/material.dart';

import '../../soar_quest.dart';

class MiniAppTestingScreen extends Screen {
  MiniAppTestingScreen() : super('Mini App Testing Screen');

  late final MiniAppCollection miniAppCollection;

  @override
  void initScreen() {
    miniAppCollection = MiniAppCollection(
      id: 'Test Telegram Collection',
      fields: [SQStringField('Name'), SQIntField('Int field')],
    );
    super.initScreen();
  }

  @override
  void refreshBackButton() {
    MiniApp.backButton.callback = () async => MiniApp.showPopup(PopupParams(
            message: 'Back button clicked!',
            title: 'Back Button Popup',
            buttons: [
              PopupButton(
                text: 'Close Mini App',
                type: PopupButtonType.destructive,
                id: 'close',
                onPressed: () => MiniApp.close,
              ),
              PopupButton(text: 'Ok', type: PopupButtonType.ok),
            ]));
  }

  @override
  void refreshMainButton() {}

  @override
  Widget screenBody() => ListView(shrinkWrap: true, children: [
        ListTile(title: SQButton('Refresh', onPressed: refresh)),
        miniAppDebug(),
        webAppInitDataDebug(MiniApp.initData),
        webAppUserDebug(MiniApp.initData.user),
        themeParamsDebug(MiniApp.themeParams),
        backButtonDebug(MiniApp.backButton),
        mainButtonDebug(MiniApp.mainButton),
        cloudStorageDebug(MiniApp.cloudStorage),
        popupsDebug(),
      ]);

  Widget miniAppDebug() => Card(
        child: Column(
          children: [
            Text('Mini App', style: Theme.of(context).textTheme.headlineMedium),
            Text('version: ${MiniApp.version}'),
            Text('platform: ${MiniApp.platform}'),
            Text('colorScheme: ${MiniApp.colorScheme.name}'),
            Text('isExpanded: ${MiniApp.isExpanded}'),
            Text('viewportHeight: ${MiniApp.viewportHeight}'),
            Text('viewportStableHeight: ${MiniApp.viewportStableHeight}'),
            Text('headerColor: ${MiniApp.headerColor}'),
            Text('backgroundColor: ${MiniApp.backgroundColor}'),
            Text(
                '''isClosingConfirmationEnabled: ${MiniApp.isClosingConfirmationEnabled}'''),
            SQButton('Is version at least 6.9?',
                onPressed: () async => MiniApp.showAlert(
                    MiniApp.isVersionAtLeast('6.9').toString())),
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: [
                SQButton(
                  'Set header color',
                  onPressed: () => MiniApp.setHeaderColor(Colors.green),
                ),
                SQButton(
                  'Set background color',
                  onPressed: () => MiniApp.setBackgroundColor(Colors.amber),
                ),
              ],
            ),
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: [
                SQButton(
                  'Enable closing confirmation',
                  onPressed: () {
                    MiniApp.enableClosingConfirmation();
                    refresh();
                  },
                ),
                SQButton(
                  'Disable',
                  onPressed: () {
                    MiniApp.disableClosingConfirmation();
                    refresh();
                  },
                ),
              ],
            ),
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: [
                SQButton(
                  'Open external link',
                  onPressed: () => MiniApp.openLink(
                      'https://github.com/ElBatanony/soar_quest'),
                ),
                SQButton(
                  'Open instant view link',
                  onPressed: () => MiniApp.openLink('https://telegra.ph/api',
                      tryInstantView: true),
                ),
              ],
            ),
            SQButton('Open Telegram Link',
                onPressed: () =>
                    MiniApp.openTelegramLink('https://t.me/soar_quest')),
            SQButton('Scan QR', onPressed: () async {
              final ret = await MiniApp.showScanQrPopup(
                  ScanQrPopupParams('Scanning the QR'));
              debugPrint(ret.toString());
              if (ret != null && ret.contains('SCANNED'))
                MiniApp.closeScanQrPopup();
              await MiniApp.showAlert(ret.toString());
            }),
            const SQButton('Request write access',
                onPressed: MiniApp.requestWriteAccess),
            const SQButton('Request contact',
                onPressed: MiniApp.requestContact),
            const SQButton('Ready', onPressed: MiniApp.ready),
            const SQButton('Expand', onPressed: MiniApp.expand),
            const SQButton('Close', onPressed: MiniApp.close),
          ],
        ),
      );

  Widget webAppInitDataDebug(WebAppInitData initData) => Card(
        child: Column(
          children: [
            Text('WebAppInitData',
                style: Theme.of(context).textTheme.headlineMedium),
            Text('query_id?: ${initData.queryId}'),
            Text('chat_type?: ${initData.chatType}'),
            Text('chat_instance?: ${initData.chatInstance}'),
            Text('can_send_after?: ${initData.canSendAfter}'),
            Text('auth_date: ${initData.authDate}'),
            Text('hash: ${initData.hash}'),
          ],
        ),
      );

  Widget webAppUserDebug(WebAppUser user) => Card(
        child: Column(
          children: [
            Text('WebAppUser',
                style: Theme.of(context).textTheme.headlineMedium),
            Text('id: ${user.id}'),
            Text('first_name: ${user.firstName}'),
            Text('last_name?: ${user.lastName}'),
            Text('username?: ${user.username}'),
            Text('language_code?: ${user.languageCode}'),
            Text('is_premium?: ${user.isPremium}'),
            Text('allows_write_to_pm : ${user.allowsWriteToPm}'),
          ],
        ),
      );

  Widget themeParamsDebug(ThemeParams tp) => Card(
        child: Column(
          children: [
            Text('ThemeParams',
                style: Theme.of(context).textTheme.headlineMedium),
            Text('bg_color?: ${tp.bgColor}'),
            Text('text_color?: ${tp.textColor}'),
            Text('hint_color?: ${tp.hintColor}'),
            Text('link_color?: ${tp.linkColor}'),
            Text('button_color?: ${tp.buttonColor}'),
            Text('button_text_color?: ${tp.buttonTextcolor}'),
            Text('secondary_bg_color?: ${tp.secondaryBgColor}'),
          ],
        ),
      );

  Widget backButtonDebug(MiniAppBackButton backButton) => Card(
        child: Column(
          children: [
            Text('BackButton',
                style: Theme.of(context).textTheme.headlineMedium),
            Text('isVisible: ${backButton.isVisible}'),
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: [
                SQButton('Show BackButton', onPressed: backButton.show),
                SQButton('Hide', onPressed: backButton.hide),
              ],
            )
          ],
        ),
      );

  Widget mainButtonDebug(MainButton mainButton) => Card(
        child: Column(
          children: [
            Text('MainButton',
                style: Theme.of(context).textTheme.headlineMedium),
            Text('text: ${mainButton.text}'),
            Text('color: ${mainButton.color}'),
            Text('textColor: ${mainButton.textColor}'),
            Text('isVisible: ${mainButton.isVisible}'),
            Text('isActive: ${mainButton.isActive}'),
            Text('isProgressVisible: ${mainButton.isProgressVisible}'),
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: [
                SQButton('Text A',
                    onPressed: () => mainButton.setText('AAAAA')),
                SQButton('Text B',
                    onPressed: () => mainButton.setText('BBBBB')),
              ],
            ),
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: [
                SQButton('Action 1',
                    onPressed: () => mainButton.callback =
                        () async => MiniApp.showAlert('Action 1')),
                SQButton('Action 2',
                    onPressed: () => mainButton.callback =
                        () async => MiniApp.showAlert('Action 2')),
              ],
            ),
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: [
                SQButton('Show MainButton', onPressed: mainButton.show),
                SQButton('Hide', onPressed: mainButton.hide),
              ],
            ),
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: [
                SQButton('Enable MainButton', onPressed: mainButton.enable),
                SQButton('Disable', onPressed: mainButton.disable),
              ],
            ),
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: [
                SQButton('Show Progress', onPressed: mainButton.showProgress),
                SQButton('Hide Progress', onPressed: mainButton.hideProgress),
              ],
            ),
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: [
                SQButton(
                  'Theme A',
                  onPressed: () => mainButton.setParams(
                    text: 'Theme A',
                    color: Colors.red,
                    textColor: Colors.purple,
                  ),
                ),
                SQButton(
                  'Theme B',
                  onPressed: () => mainButton.setParams(
                    text: 'Theme B',
                    color: Colors.blueGrey,
                    textColor: Colors.green,
                  ),
                ),
              ],
            ),
          ],
        ),
      );

  Widget cloudStorageDebug(CloudStorage cloudStorage) => Card(
        child: Column(
          children: [
            Text('CloudStorage',
                style: Theme.of(context).textTheme.headlineMedium),
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: [
                SQButton('Set Test key to X',
                    onPressed: () async => cloudStorage.setItem('Test', 'X')),
                SQButton('Set to Y',
                    onPressed: () async => cloudStorage.setItem('Test', 'Y')),
              ],
            ),
            SQButton('Get value of Test key',
                onPressed: () async => MiniApp.showAlert(
                    await cloudStorage.getItem<String>('Test') ??
                        'No value stored')),
            SQButton('Remove Test key',
                onPressed: () async => cloudStorage.removeItem('Test')),
            SQButton(
              'Read all keys',
              onPressed: () async =>
                  MiniApp.showAlert((await cloudStorage.getKeys()).toString()),
            ),
            SQButton('View Test Mini App Collection',
                onPressed: () async => navigateTo(
                    CollectionScreen(collection: miniAppCollection))),
          ],
        ),
      );

  Widget popupsDebug() => Card(
        child: Column(
          children: [
            Text('Popups', style: Theme.of(context).textTheme.headlineMedium),
            SQButton('Show Popup', onPressed: () async {
              final ret = await MiniApp.showPopup(PopupParams(
                message: 'Popup Message',
                title: 'Popup Title',
                buttons: [
                  PopupButton(
                      id: 'btnOk', text: 'OK', type: PopupButtonType.ok),
                  PopupButton(
                      id: 'btnClose',
                      text: 'Close',
                      type: PopupButtonType.close),
                  PopupButton(
                      id: 'btnDestructive',
                      text: 'Destructive',
                      type: PopupButtonType.destructive,
                      onPressed: () => MiniApp.showAlert('Destruction!')),
                ],
              ));
              if (ret.isNotEmpty) if (context.mounted)
                showSnackBar('Selected: $ret', context: context);
            }),
            SQButton('Show alert', onPressed: () async {
              await MiniApp.showAlert('This is an alert!');
              if (context.mounted)
                showSnackBar('Alert closed', context: context);
            }),
            SQButton('Show confirm', onPressed: () async {
              final confirmed =
                  await MiniApp.showConfirm('Do you confirm this test?');
              if (confirmed && context.mounted)
                showSnackBar('Confirmed!', context: context);
            }),
          ],
        ),
      );
}
