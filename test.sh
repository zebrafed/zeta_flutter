set -e
behind_by='err'
behind_by=$(gh api /repos/zebrafed/zeta_flutter/compare/ccaf8a98123c46f3415fd02fad5df655a91b3ac63...3501388bb4a443s0994efb7c4ef9948b0501843b0 | jq .behind_by ) || true 

if [ "$behind_by" == 'err' ]; then
    echo '⚠️ - Can not communicate with Github API'
elif [ $behind_by -eq 0 ]; then
  echo '✅ - Branch is not behind'
else 
  echo '⛔️ - Branch is behind'
fi