# GitHub Actions Build Fix - Authentication Issue

## Problem Summary

The GitHub Actions workflow was failing with authentication errors when trying to checkout submodules:
```
Error: fatal: could not read Username for 'https://github.com': terminal prompts disabled
```

## Root Cause

The `.gitmodules` file was using **SSH URLs** (`git@github.com:...`) but GitHub Actions was configured to use **token-based authentication** (HTTPS). This mismatch caused the checkout to fail when accessing private submodules.

## Solution Applied

### ✅ Converted Submodules to HTTPS URLs

Updated `.gitmodules` from SSH to HTTPS format:

**Before:**
```
url = git@github.com:verdikta/verdikta-arbiter.git
```

**After:**
```
url = https://github.com/verdikta/verdikta-arbiter.git
```

This change was applied to all four submodules:
- sources/arbiter → verdikta-arbiter
- sources/dispatcher → verdikta-dispatcher  
- sources/apps → verdikta-applications
- sources/common → verdikta-common

### ✅ Synced Local Configuration

Ran `git submodule sync --recursive` to update local git configuration with the new HTTPS URLs.

## Required: Verify PAT_TOKEN Permissions

The workflow uses `${{ secrets.PAT_TOKEN }}` for authentication. **You need to verify this token has the correct permissions.**

### GitHub Personal Access Token Requirements

The `PAT_TOKEN` secret must have these permissions:

#### Classic Personal Access Token
If using a classic token, it needs:
- ✅ **repo** (Full control of private repositories)
- ✅ **workflow** (Update GitHub Action workflows)

#### Fine-grained Personal Access Token  
If using fine-grained tokens, it needs:
- ✅ **Contents**: Read and write
- ✅ **Metadata**: Read-only
- ✅ **Actions**: Read and write

And it must have access to **all five repositories**:
1. verdikta/verdikta-docs
2. verdikta/verdikta-arbiter
3. verdikta/verdikta-dispatcher
4. verdikta/verdikta-applications
5. verdikta/verdikta-common

### How to Verify/Update the Token

1. Go to GitHub Settings → Developer settings → Personal access tokens
2. Find the token being used (or create a new one)
3. Ensure it has the permissions listed above
4. If it's expired or missing permissions, generate a new token
5. Update the `PAT_TOKEN` secret in the repository:
   - Go to: https://github.com/verdikta/verdikta-docs/settings/secrets/actions
   - Update or add `PAT_TOKEN` with the new token value

## Next Steps

1. **Commit the .gitmodules changes:**
   ```bash
   git add .gitmodules
   git commit -m "Fix: Convert submodules to HTTPS URLs for GitHub Actions compatibility"
   git push origin main
   ```

2. **Verify PAT_TOKEN:** Check that the token exists and has proper permissions (see above)

3. **Test the workflow:** 
   - The push will trigger the GitHub Action automatically
   - Or manually trigger it from: https://github.com/verdikta/verdikta-docs/actions

4. **Monitor the build:**
   - Watch the "Checkout repository" step - it should now succeed
   - All submodules should be fetched without authentication errors

## Additional Notes

### Local Development
- Your local SSH setup is unaffected - you can still use SSH for personal development
- The `.gitmodules` change only affects how the URLs are stored in git config
- Your local git credentials will continue to work as before

### Submodule Updates
When updating submodules locally, you can continue using your existing workflow:
```bash
git submodule update --remote --recursive
```

The HTTPS URLs will work with your local git credential helper automatically.

## Troubleshooting

If the build still fails after these changes:

1. **Token expired?** Generate a new PAT and update the secret
2. **Wrong permissions?** Verify the token has access to all 5 repos
3. **Token not set?** Ensure `PAT_TOKEN` exists in repository secrets
4. **Still using SSH?** Run `git submodule sync` again locally and push

## References

- GitHub Actions Checkout: https://github.com/actions/checkout
- Git Submodules Documentation: https://git-scm.com/book/en/v2/Git-Tools-Submodules
- GitHub PAT Documentation: https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens

