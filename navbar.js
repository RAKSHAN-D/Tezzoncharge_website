document.addEventListener("DOMContentLoaded", function () {
    const navbarHTML = `
    <nav class="navbar navbar-expand-lg fixed-top shadow-sm" style="background: linear-gradient(135deg, #0056b3 0%, white 100%);">
        <div class="container">
            <a class="navbar-brand fw-bold d-flex align-items-center" href="index.html">
                <i class="fas fa-bolt me-2" style="color: #ff8f00;"></i>Tezzon Charge
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="index.html" id="nav-home">
                            <i class="fas fa-home me-1"></i>Home
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="technology.html" id="nav-technology">
                            <i class="fas fa-microchip me-1"></i>Technology
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="products.html" id="nav-products">
                            <i class="fas fa-box me-1"></i>Products
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="FAQ.html" id="nav-faq">
                            <i class="fas fa-question-circle me-1"></i>FAQ's
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="About_us.html" id="nav-about">
                            <i class="fas fa-info-circle me-1"></i>About
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="Partnerships.html" id="nav-partnerships">
                            <i class="fas fa-handshake me-1"></i>Partnerships
                        </a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>
    `;

    // Inject navbar
    const placeholder = document.getElementById("navbar-placeholder");
    if (placeholder) {
        placeholder.innerHTML = navbarHTML;
    }

    // Highlight active link
    const currentPath = window.location.pathname.split("/").pop() || "index.html";
    const navLinks = {
        "index.html": "nav-home",
        "technology.html": "nav-technology",
        "products.html": "nav-products",
        "FAQ.html": "nav-faq",
        "About_us.html": "nav-about",
        "Partnerships.html": "nav-partnerships",
        "become-a-partner.html": "nav-become-partner"
    };

    // Handle product sub-pages (keep Products active)
    if (currentPath.startsWith("product-") || currentPath.startsWith("brochure-")) {
        document.getElementById("nav-products")?.classList.add("active", "fw-bold", "text-primary");
    } else {
        const activeId = navLinks[currentPath];
        if (activeId) {
            document.getElementById(activeId)?.classList.add("active", "fw-bold", "text-primary");
        }
    }
});
