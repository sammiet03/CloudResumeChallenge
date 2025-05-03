## GitHub Secrets Management and Scanning

### Overview
This guide explains how to prevent, detect, and respond if secrets (like AWS keys, passwords, tokens) are accidentally committed to a GitHub repository.


### Best Practices for Secrets Management
- **Never** hardcode secrets (use environment variables, secret managers, or encrypted files).
- **Use `.gitignore`** to prevent committing local credential files.
- **Enable GitHub's Secret Scanning Alerts** in your repository settings.
- **Rotate and delete secrets immediately** if they are exposed.


### How to Check for Exposed Secrets

### 1. Scan Your Repo Using Git Commands

Scan Git history for sensitive patterns:

```
git log -p | grep -Ei 'AKIA|ASIA|A3T|aws_secret_access_key|password|token'
```

Scan the working directory:

```
git grep -i 'AKIA\|ASIA\|aws_secret_access_key\|password\|token'
```

### 2. Use `git-secrets` to Detect Secrets

Install [git-secrets](https://github.com/awslabs/git-secrets):

```
brew install git-secrets   # macOS
# or
git clone https://github.com/awslabs/git-secrets.git
cd git-secrets
sudo make install
```

Scan your repository:

```
git secrets --scan
git secrets --scan-history
```


### 3. Enable GitHub Secret Scanning (Recommended)

- Go to **Settings** > **Security** > **Code security and analysis**.
- Enable **Secret scanning** for private repositories.

GitHub will alert you if any exposed secrets are detected.


### What To Do If You Accidentally Commit a Secret

1. **Revoke and rotate** the secret immediately.
2. **Remove the secret from Git history**:

Using `git filter-repo`:

```
git filter-repo --path YOUR_FILE --invert-paths
```

Or using `git filter-branch`:

```
git filter-branch --force --index-filter \
  "git rm --cached --ignore-unmatch PATH_TO_FILE" \
  --prune-empty --tag-name-filter cat -- --all
```

3. **Force-push cleaned history:**

```
git push origin --force --all
git push origin --force --tags
```

### Helpful Tools
- [git-secrets](https://github.com/awslabs/git-secrets)
- [truffleHog](https://github.com/trufflesecurity/trufflehog)
- [gitleaks](https://github.com/gitleaks/gitleaks)

### Quick Checklist Before Pushing Code

- [ ] `.env`, `credentials`, `.aws/credentials` files are ignored.
- [ ] No hardcoded secrets in source code.
- [ ] Repository scanned for secrets (`git secrets --scan-history`).
- [ ] Secrets managed via a secure vault (AWS Secrets Manager, Vault, GitHub Secrets).
