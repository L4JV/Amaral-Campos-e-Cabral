// Amaral, Campos e Cabral Advocacia — interações do site
document.addEventListener('DOMContentLoaded', function () {

  // Menu mobile
  var toggle = document.querySelector('.menu-toggle');
  var links = document.querySelector('nav.links');
  if (toggle && links) {
    toggle.addEventListener('click', function () {
      links.classList.toggle('open');
      toggle.setAttribute('aria-expanded', links.classList.contains('open'));
    });
  }

  // Formulário de contato (demonstração — sem backend conectado)
  var form = document.getElementById('form-contato');
  if (form) {
    form.addEventListener('submit', function (e) {
      e.preventDefault();
      var feedback = document.getElementById('form-feedback');
      var nome = form.querySelector('#nome').value.trim();
      if (!nome) return;
      form.style.display = 'none';
      feedback.hidden = false;
      feedback.focus();
    });
  }

  // Botão de checkout do curso (placeholder — substituir pelo link real do Hotmart/gateway)
  document.querySelectorAll('[data-checkout]').forEach(function (btn) {
    btn.addEventListener('click', function (e) {
      var href = btn.getAttribute('href');
      if (!href || href === '#') {
        e.preventDefault();
        alert('Substitua este botão pelo link de checkout real (ex.: Hotmart) assim que o produto estiver configurado.');
      }
    });
  });
});
