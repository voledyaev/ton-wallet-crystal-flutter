import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../domain/blocs/account/account_info_provider.dart';
import '../../../../../domain/blocs/key/current_key_provider.dart';
import '../../../../../domain/blocs/key/keys_provider.dart';
import '../../../../../domain/blocs/ton_wallet/ton_wallet_info_provider.dart';
import '../../../../design/design.dart';
import '../modals/add_asset_modal/show_add_asset_modal.dart';
import '../modals/deploy_wallet_flow/start_deploy_wallet_flow.dart';
import '../modals/receive_modal/show_receive_modal.dart';
import '../modals/send_transaction_flow/start_send_transaction_flow.dart';
import 'wallet_button.dart';

class ProfileActions extends StatelessWidget {
  final String address;

  const ProfileActions({
    Key? key,
    required this.address,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          WalletButton(
            onTap: () async => showAddAssetModal(
              context: context,
              address: address,
            ),
            title: LocaleKeys.wallet_screen_actions_add_asset.tr(),
            icon: const OverflowBox(
              maxHeight: 30,
              maxWidth: 30,
              child: Center(
                child: Icon(
                  Icons.add,
                  size: 30,
                  color: CrystalColor.secondary,
                ),
              ),
            ),
          ),
          Consumer(
            builder: (context, ref, child) {
              final value = ref.watch(accountInfoProvider(address)).asData?.value;

              return WalletButton(
                onTap: value != null
                    ? () => showReceiveModal(
                          context: context,
                          address: value.address,
                        )
                    : null,
                title: LocaleKeys.actions_receive.tr(),
                icon: Assets.images.iconReceive.svg(
                  color: CrystalColor.secondary,
                ),
              );
            },
          ),
          Consumer(
            builder: (context, ref, child) {
              final keys = ref.watch(keysProvider).asData?.value ?? {};
              final currentKey = ref.watch(currentKeyProvider).asData?.value;
              final tonWalletInfo = ref.watch(tonWalletInfoProvider(address)).asData?.value;

              if (currentKey != null && tonWalletInfo != null) {
                final publicKey = currentKey.publicKey;
                final requiresSeparateDeploy = tonWalletInfo.details.requiresSeparateDeploy;
                final isDeployed = tonWalletInfo.contractState.isDeployed;

                if (!requiresSeparateDeploy || isDeployed) {
                  final items = [
                    ...keys.keys,
                    ...keys.values.whereNotNull().expand((e) => e),
                  ];
                  final publicKeys =
                      tonWalletInfo.custodians?.where((e) => items.any((el) => el.publicKey == e)).toList() ??
                          [publicKey];

                  return WalletButton(
                    onTap: () => startSendTransactionFlow(
                      context: context,
                      address: address,
                      publicKeys: publicKeys,
                    ),
                    title: LocaleKeys.actions_send.tr(),
                    icon: Assets.images.iconSend.svg(
                      color: CrystalColor.secondary,
                    ),
                  );
                } else {
                  return WalletButton(
                    onTap: () => startDeployWalletFlow(
                      context: context,
                      address: address,
                      publicKey: publicKey,
                    ),
                    title: LocaleKeys.actions_deploy.tr(),
                    icon: Assets.images.iconDeploy.svg(
                      color: CrystalColor.secondary,
                    ),
                  );
                }
              } else {
                return WalletButton(
                  onTap: () {},
                  title: LocaleKeys.actions_send.tr(),
                  icon: Assets.images.iconSend.svg(
                    color: CrystalColor.secondary,
                  ),
                );
              }
            },
          ),
        ],
      );
}