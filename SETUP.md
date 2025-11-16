# セットアップ手順

## 1. GitHubリポジトリ作成

1. https://github.com/new にアクセス
2. リポジトリ名: `terraform-sandbox-demo`
3. Public を選択
4. 「Create repository」をクリック

## 2. AWS認証情報をGitHub Secretsに登録

1. リポジトリの「Settings」→「Secrets and variables」→「Actions」
2. 「New repository secret」をクリック
3. 以下2つを登録:
   - Name: `AWS_ACCESS_KEY_ID`
     Value: (あなたのAWS Access Key ID)
   - Name: `AWS_SECRET_ACCESS_KEY`
     Value: (あなたのAWS Secret Access Key)

## 3. ローカルでGit初期化

```bash
cd C:\Users\80kid\AppData\Local\Temp\aws-api-mcp\workdir\terraform
git init
git add .
git commit -m "Initial commit"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/terraform-sandbox-demo.git
git push -u origin main
```

## 4. サブネット追加の体験

### ブランチ作成
```bash
git checkout -b feature/add-subnet
```

### main.tfに追加
```hcl
# Public Subnet 3 (ap-northeast-1d)
resource "aws_subnet" "public_3" {
  vpc_id                  = aws_vpc.test_network.id
  cidr_block              = "10.0.32.0/20"
  availability_zone       = "ap-northeast-1d"
  map_public_ip_on_launch = true

  tags = {
    Name = "test-network-subnet-public3-ap-northeast-1d"
  }
}

resource "aws_route_table_association" "public_3" {
  subnet_id      = aws_subnet.public_3.id
  route_table_id = aws_route_table.public.id
}
```

### コミット & プッシュ
```bash
git add main.tf
git commit -m "Add public subnet 3"
git push origin feature/add-subnet
```

### Pull Request作成
1. GitHubでPR作成
2. GitHub Actionsが自動実行
3. Plan結果を確認
4. Merge
5. 自動的にterraform applyが実行される

## 5. 削除

全リソース削除:
```bash
terraform destroy
```

AWS State管理リソース削除:
```bash
aws s3 rb s3://terraform-state-sandbox-80kid --force --profile AdministratorAccess-613860946721
aws dynamodb delete-table --table-name terraform-locks --region ap-northeast-1 --profile AdministratorAccess-613860946721
```
