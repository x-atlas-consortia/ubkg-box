function loadJSYaml(callback) {
  var script = document.createElement('script');
  script.src = 'https://cdn.jsdelivr.net/npm/js-yaml@4.1.0/dist/js-yaml.min.js';
  script.onload = callback;
  document.head.appendChild(script);
}

loadJSYaml(function() {
  window.onload = function() {
    var serverUrl = window.SWAGGER_SERVER_URL || "http://localhost:7070/api";
    var yamlUrl = window.SWAGGER_YAML_URL;
    fetch(yamlUrl)
      .then(response => response.text())
      .then(yamlText => {
        const spec = jsyaml.load(yamlText);
        spec.servers = [{ url: serverUrl }];
        window.ui = SwaggerUIBundle({
          spec: spec,
          dom_id: '#swagger-ui',
          deepLinking: true,
          presets: [
            SwaggerUIBundle.presets.apis,
            SwaggerUIStandalonePreset
          ],
          layout: "StandaloneLayout"
        });
      });
  }
});