TopbarPlus supports the use of multiple Icon packages within a single experience assuming all required packages are ``v3.0.0`` or above.

When a package is required it will 'check' to see if a TopbarPlus package has already been required within the experience. If one has, it cancels loading itself and will instead refer to the already initialized package.

This prevents weird quirks from occuring and means third party applications, libraries etc that use TopbarPlus can be used safely without interferring with your own implementation of TopbarPlus.

You don't have to do anything to support multiple packages. Simply use TopbarPlus as normal.