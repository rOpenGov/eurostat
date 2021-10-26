// Nice touch with JavaScrip

let foot = document.getElementsByClassName("pkgdown-footer-left");

if (foot.length > 0) {
  footdiv = foot[0];

  text = '<p class="mt-4">Part of <a href="http://ropengov.org/">' +
    '<img src="https://raw.githubusercontent.com/rOpenGov/homepage/master/static/images/logo2020_white_orange.svg"' +
    ' height="20" class="d-inline-block mx-1 rog-logo" alt="rOpenGov R packages for open government data analytics"' +
    '></a></p>';

  footdiv.innerHTML += text

}
