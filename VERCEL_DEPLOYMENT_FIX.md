# Vercel Deployment Fix - Automatic Deployment

## Problem Summary

After fixing the GitHub Actions authentication issue, the workflow failed at the Vercel deployment step with:
```
Error: Git author action@github.com must have access to the team Neil's projects on Vercel to create deployments.
```

## Root Cause

The workflow was trying to **manually deploy** to Vercel using the Vercel CLI, which requires special team permissions. This approach is overly complex and error-prone.

## Solution: Use Vercel's Automatic GitHub Integration

Instead of manually deploying from GitHub Actions, we let **Vercel automatically deploy** when changes are pushed to GitHub.

### Changes Made

#### 1. Simplified GitHub Actions Workflow

**Removed:**
- Python setup
- Node.js setup  
- Dependencies installation
- Smart contract documentation generation
- MkDocs build step
- Vercel CLI installation
- Manual Vercel deployment

**Now the workflow only:**
- Updates submodules from source repositories
- Commits and pushes changes to main branch
- Lets Vercel detect the changes and deploy automatically

#### 2. Updated Vercel Configuration

Updated `vercel.json` to tell Vercel how to build the site:

```json
{
  "buildCommand": "pip install -r requirements.txt && mkdocs build",
  "installCommand": "python3 -m pip install --upgrade pip",
  "outputDirectory": "site",
  "framework": null
}
```

## How It Works Now

### Automatic Deployment Flow

```
1. Source repo (arbiter/dispatcher/apps/common) updates docs
2. GitHub Actions runs every 6 hours (or on manual trigger)
3. Workflow pulls latest from all submodules
4. If changes detected:
   - Commits updated submodule references
   - Pushes to verdikta-docs main branch
5. Vercel detects push to main
6. Vercel automatically:
   - Installs Python dependencies
   - Runs mkdocs build
   - Deploys to docs.verdikta.org
```

### Benefits

✅ **Simpler workflow** - No manual deployment logic  
✅ **No team permissions needed** - Vercel uses its GitHub integration  
✅ **Automatic previews** - Get preview deployments for PRs  
✅ **Better error handling** - Vercel's UI shows build logs clearly  
✅ **Faster deployments** - Vercel's edge network is optimized for this  
✅ **Rollback support** - Easy to rollback to previous deployments in Vercel UI

## Vercel Configuration Requirements

Ensure the Vercel project is properly connected to GitHub:

### 1. Check GitHub Integration

1. Go to your Vercel project: https://vercel.com/dashboard
2. Navigate to Settings → Git
3. Verify it's connected to `verdikta/verdikta-docs`
4. Ensure "Production Branch" is set to `main`

### 2. Build Settings (should match vercel.json)

- **Framework Preset**: Other
- **Build Command**: `pip install -r requirements.txt && mkdocs build`
- **Output Directory**: `site`
- **Install Command**: `python3 -m pip install --upgrade pip`

### 3. Environment Variables (if needed)

If you were using any secrets for the build:
- `GOOGLE_ANALYTICS_KEY` (optional)
- Any other environment-specific variables

## GitHub Secrets No Longer Needed

You can safely remove these secrets from the repository (they're not used anymore):
- ❌ `VERCEL_TOKEN`
- ❌ `VERCEL_ORG_ID`  
- ❌ `VERCEL_PROJECT_ID`

**Keep these:**
- ✅ `PAT_TOKEN` - Still needed for submodule access

## Testing the New Setup

### Test 1: Manual Workflow Trigger

1. Go to: https://github.com/verdikta/verdikta-docs/actions
2. Select "Update Documentation" workflow
3. Click "Run workflow" → "Run workflow"
4. Watch it complete (should only take 10-20 seconds)
5. Check Vercel dashboard for automatic deployment

### Test 2: Submodule Update

1. Make a change to any source repo's docs
2. Wait 6 hours for automatic check (or trigger manually)
3. Workflow should detect the change and push
4. Vercel should automatically deploy

### Test 3: Direct Push

1. Make a change to `docs/index.md` locally
2. Commit and push to main
3. Vercel should immediately start building
4. Check deployment at docs.verdikta.org

## Monitoring

### GitHub Actions
- View workflow runs: https://github.com/verdikta/verdikta-docs/actions
- Should see successful "Update Documentation" runs every 6 hours

### Vercel Dashboard  
- View deployments: https://vercel.com/dashboard
- Each push to main creates a new Production deployment
- Build logs show if MkDocs build succeeds/fails

## Troubleshooting

### Workflow succeeds but Vercel doesn't deploy

**Possible causes:**
- Vercel GitHub integration disconnected → Reconnect in Vercel settings
- Wrong branch configured → Ensure "main" is the production branch
- Build command failing → Check Vercel build logs

### Vercel build fails

**Check Vercel logs for:**
- Missing dependencies in `requirements.txt`
- Invalid `mkdocs.yml` configuration
- Missing submodule content (needs `git submodules` in Vercel)

**Solution:** Vercel should automatically handle submodules. If not:
1. Go to Project Settings → Git
2. Enable "Git Submodules" option

### Submodules not updating

- Check GitHub Actions logs for errors
- Verify `PAT_TOKEN` hasn't expired
- Ensure token has access to all 5 repositories

## Migration Complete

The deployment pipeline is now simplified and more reliable:

- ✅ GitHub Actions: Submodule management only
- ✅ Vercel: Automatic deployment via GitHub integration  
- ✅ No manual deployment needed
- ✅ No team permission issues
- ✅ Clear separation of concerns

## Next Steps

1. Commit these changes:
   ```bash
   git add .github/workflows/update-docs.yml vercel.json
   git commit -m "Fix: Simplify workflow and use Vercel automatic deployment"
   git push origin main
   ```

2. Watch Vercel automatically deploy the changes

3. Verify the site builds successfully at docs.verdikta.org

4. Test the submodule update workflow works end-to-end

