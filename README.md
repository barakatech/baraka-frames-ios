# Why the need of this fork?

At baraka our app requires latest version of PhoneNumberKit `4.0.2` because of the updated KW validation manifest. Since the support for the Frames moved to [Flow](https://github.com/checkout/checkout-ios-components) stated [here](https://www.checkout.com/docs/payments/accept-payments/upgrade-to-flow-from-frames/upgrade-from-frames-for-ios). So until migration to Flow is done this fork will be actively used.

# Fork changes

In the source repository, the PhoneNumberKit version is `3.5.9`. In this for upgraded to `4.0.2`. Re-Add missing helpers & extension that baraka used, that been removed on newer versions of Frames package.

Code changes:
- Replace `PhoneNumberKit` with `PhoneNumberUtility`
- Fixed some deprecated Xcode 16 warnings.
- Add `standardize()` `isValid()` `getTypeOf()` `luhnCheck()` functions inside `Cardutils.swift` file.
- Re-add `ExpirationDatePickerDelegate` `ExpirationDatePicker` that been removed on latest versions.
- Update Risk Sdk to version `3.0.3`.


# Integration Flow
1. Add SPM dependency: 
``` 
https://github.com/barakatech/baraka-frames-ios.git
```

## For more infos please refer to source [documentation](https://github.com/checkout/frames-ios)
