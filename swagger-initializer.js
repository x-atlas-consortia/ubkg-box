window.ui = SwaggerUIBundle({
  url: "https://raw.githubusercontent.com/x-atlas-consortia/ubkg-api/refs/heads/jas_ubkgbox/ubkg-api-ubkgbox-spec.yaml",
  dom_id: "#swagger-ui",
  deepLinking: true,
  presets: [
    SwaggerUIBundle.presets.apis,
    SwaggerUIStandalonePreset
  ],
  plugins: [
    SwaggerUIBundle.plugins.DownloadUrl
  ],
  layout: "StandaloneLayout",
  queryConfigEnabled: false,
});



