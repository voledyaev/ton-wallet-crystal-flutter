import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nekoton_flutter/nekoton_flutter.dart';

import '../../../../../domain/blocs/ton_wallet/ton_wallet_info_provider.dart';
import '../../../../design/design.dart';
import '../modals/ton_asset_info/show_ton_asset_info.dart';
import 'wallet_asset_holder.dart';

class TonWalletAssetHolder extends StatefulWidget {
  final String address;

  const TonWalletAssetHolder({
    Key? key,
    required this.address,
  }) : super(key: key);

  @override
  _TonWalletAssetHolderState createState() => _TonWalletAssetHolderState();
}

class _TonWalletAssetHolderState extends State<TonWalletAssetHolder> {
  @override
  Widget build(BuildContext context) => Consumer(
        builder: (context, ref, child) {
          final tonWalletInfo = ref.watch(tonWalletInfoProvider(widget.address)).asData?.value;

          return WalletAssetHolder(
            name: 'TON',
            balance: tonWalletInfo != null ? tonWalletInfo.contractState.balance : '0',
            decimals: kTonDecimals,
            icon: Assets.images.ton.svg(),
            onTap: tonWalletInfo != null
                ? () => showTonAssetInfo(
                      context: context,
                      address: tonWalletInfo.address,
                    )
                : () {},
          );
        },
      );
}