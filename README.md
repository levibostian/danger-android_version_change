

### android_version_change

Asserts the versionName or versionCode strings have been changed in your Android project.
This is done by checking the git diff of your project's build.gradle file.
The plugin will either call Danger's fail method or do nothing if the versionName or versionCode strings were changed.

  android_version_change.assert_version_name_changed()

   # Calls Danger `fail` if the versionName not updated or nothing if it has changed.
  android_version_change.assert_version_code_changed()

<blockquote>Assert the versionName string changed for your Android project
  <pre># Calls Danger `fail` if the versionName not updated or nothing if it has changed.</pre>
</blockquote>





#### Methods

`assert_version_changed_diff` - (Internal use) Pass the git diff string here to see if the version string has been updated.

`assert_version_changed` - 

`assert_version_name_changed` - Assert the versionName has been changed in your build.gradle file.

  android_version_change.assert_version_name_changed()

  # If your build.gradle file is not located in the default location: `app/build.gradle`
  android_version_change.assert_version_name_changed("specialDirectory/build.gradle")

`assert_version_code_changed` - Assert the versionCode has been changed in your build.gradle file.

  android_version_change.assert_version_code_changed()

  # If your build.gradle file is not located in the default location: `app/build.gradle`
  android_version_change.assert_version_code_changed("specialDirectory/build.gradle")




