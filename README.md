# devspaces-code-assist

- Build your own devspaces plugin registry

git clone https://github.com/redhat-developer/devspaces.git

Add your plugin to the sync list

```
git diff dependencies/che-plugin-registry/openvsx-sync.json
diff --git a/dependencies/che-plugin-registry/openvsx-sync.json b/dependencies/che-plugin-registry/openvsx-sync.json
index 975ecb98a..1a437ef7f 100644
--- a/dependencies/che-plugin-registry/openvsx-sync.json
+++ b/dependencies/che-plugin-registry/openvsx-sync.json
@@ -234,5 +234,9 @@
   {
     "id": "mongodb.mongodb-vscode",
     "version": "1.9.1"
+  },
+  {
+    "id": "Continue.continue",
+    "version": "0.9.239"
   }
 ]
```

There is a known issue where the plugin registry won't pull VSCode plugins that are in a pre-release state. Update the script to allow this

```
git diff dependencies/che-plugin-registry/build/scripts/download_vsix.sh
diff --git a/dependencies/che-plugin-registry/build/scripts/download_vsix.sh b/dependencies/che-plugin-registry/build/scripts/download_vsix.sh
index 06e34cf39..53cca5a8a 100755
--- a/dependencies/che-plugin-registry/build/scripts/download_vsix.sh
+++ b/dependencies/che-plugin-registry/build/scripts/download_vsix.sh
@@ -132,11 +132,11 @@ for i in $(seq 0 "$((numberOfExtensions - 1))"); do
         getMetadata "${vsixName}" "${vsixVersion}"
 
         # check if the version is pre-release
-        preRelease=$(echo "${vsixMetadata}" | jq -r '.preRelease')
-        if [[ $preRelease == true ]]; then
-            echo "Version ${vsixVersion} is marked as pre-release  for ${vsixName}, it should be stable one"
-            exit 1
-        fi
+#        preRelease=$(echo "${vsixMetadata}" | jq -r '.preRelease')
+#        if [[ $preRelease == true ]]; then
+#            echo "Version ${vsixVersion} is marked as pre-release  for ${vsixName}, it should be stable one"
+#            exit 1
+#        fi
 
         # extract the engine version from the json metadata
         vscodeEngineVersion=$(echo "${vsixMetadata}" | jq -r '.engines.vscode')
```

Build the plugin registry

```
./build.sh -o danclark -r quay.io -t continue
```

  This will create an image like: quay.io/danclark/che-plugin-registry:continue


- Deploy the Dev Workspaces Operator
- Create a Che Cluster CR using the example CR in this repo: checluster-private-plugin-registry-image.yaml
- Create a Dev Workspace using the devfile.yaml


Note that the LLM must be deployed with RHOAI vLLM or something else like ollama
The devfile.yaml contains an embeded config.json for the VSCode continue plugin. The embeded config.json tells Continue where to find the LLM to talk to. Change these as needed.

When the Dev file is launched, you'll need to go into it and search/install the VSCode plugin for "continue" which will be pulled from the private VSCode plugin registry that Che is now using.
