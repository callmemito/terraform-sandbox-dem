# Sandbox Tokyo Region - Terraform

このTerraformコードは、AWS東京リージョン(ap-northeast-1)のsandbox環境を再現します。

## 構成内容

- **VPC**: 10.0.0.0/16
- **パブリックサブネット**: 2つ (1a, 1c)
- **プライベートサブネット**: 2つ (1a, 1c)
- **インターネットゲートウェイ**: パブリックサブネット用
- **VPCエンドポイント**: S3 Gateway型

## 使用方法

### 1. 初期化
```bash
terraform init
```

### 2. プラン確認
```bash
terraform plan
```

### 3. 適用
```bash
terraform apply
```

### 4. 削除
```bash
terraform destroy
```

## 出力

適用後、以下の情報が出力されます:
- VPC ID
- サブネットID
- インターネットゲートウェイID
- VPCエンドポイントID

## 注意事項

- このコードは既存のCloudFormationスタック(test-network-stack)と同じ構成を作成します
- 既存リソースと競合する場合は、既存リソースを削除するか、CIDR範囲を変更してください
- コストはほぼ無料です
