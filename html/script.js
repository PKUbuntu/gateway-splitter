
document.addEventListener('DOMContentLoaded', function() {
  const configSelector = document.getElementById('config-selector');
  const jsonInput = document.getElementById('json-input');
  const transformButton = document.getElementById('transform-button');
  const jsonOutput = document.getElementById('json-output');

  // Populate the dropdown with options from the rules_list.json
  fetch('rules_list.json')
    .then(response => response.json())
    .then(data => {
      data.forEach(config => {
        let option = document.createElement('option');
        option.value = config;
        option.textContent = config;
        configSelector.appendChild(option);
      });
    });

  // Enable the transform button when there is some input
  jsonInput.addEventListener('input', function() {
    transformButton.disabled = jsonInput.value.trim() === '';
  });

  // Handle the transform button click event
  transformButton.addEventListener('click', function() {
    const selectedConfig = configSelector.value;
    const jsonToSend = jsonInput.value;

    fetch(`http://localhost:8080/transform?config=${selectedConfig}`, {
      method: 'POST',
      body: jsonToSend,
      headers: {
        'Content-Type': 'application/json'
      }
    })
    .then(response => response.json())
    .then(data => {
      jsonOutput.value = JSON.stringify(data, null, 2);
    })
    .catch(error => {
      jsonOutput.value = `Error: ${error.message}`;
    });
  });
});
