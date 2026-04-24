const rootMenu = document.getElementById("root-menu");
const contractBg = document.getElementById("contract-bg");
const contractList = document.getElementById("contract-list");
const dealerBg = document.getElementById("dealer-bg");
const dealerList = document.getElementById("dealer-list");

window.addEventListener("message", function (e) {

    // ROOT MENU
    if (e.data.action === "openRoot") {
        document.body.style.display = "block";
        rootMenu.style.display = "block";
        contractBg.style.display = "none";
        dealerBg.style.display = "none";
    }

    // CONTRACT MENU
    if (e.data.action === "openContract") {
        document.body.style.display = "block";
        rootMenu.style.display = "none";
        dealerBg.style.display = "none";
        contractBg.style.display = "block";

        contractList.innerHTML = "";
        const jobs = e.data.kind === "legal" ? e.data.legal : e.data.illegal;

        jobs.forEach((job) => {
            const div = document.createElement("div");
            div.className = "contract-entry";
            div.innerHTML = `
                <span><b>${job.from}</b> → <b>${job.to}</b></span>
                <span>Payout: $${job.payout}</span>
                <span>Difficulty: ${job.difficulty}</span>
            `;
            div.onclick = () => {
                document.body.style.display = "none";
                rootMenu.style.display = "none";
                contractBg.style.display = "none";
                fetch(`https://${GetParentResourceName()}/selectJob`, {
                    method: "POST",
                    body: JSON.stringify(job)
                });
            };
            contractList.appendChild(div);
        });
    }

    // DEALERSHIP MENU
    if (e.data.action === "openDealer") {
        document.body.style.display = "block";
        dealerBg.style.display = "block";
        rootMenu.style.display = "none";
        contractBg.style.display = "none";

        dealerList.innerHTML = "";
        const preview = document.getElementById("dealer-preview-img");

        const playerLevel = e.data.playerLevel;
        const ownedPlanes = e.data.ownedPlanes || [];

        e.data.planes.forEach((plane) => {
            const div = document.createElement("div");
            div.className = "dealer-entry fadeIn";

            const locked = playerLevel < plane.level;
            const owned = ownedPlanes.includes(plane.model);

            if (locked) {
                div.classList.add("locked");
                div.setAttribute("data-req", "Requires Level " + plane.level);
            }

            div.innerHTML = `
                <span><b>${plane.label}</b></span>
                <span>Price: $${plane.price}</span>
                <span>Rent: $${plane.rent}</span>
                <span>Required Level: ${plane.level}</span>
            `;

            div.onmouseenter = () => {
                preview.style.opacity = "0";
                setTimeout(() => {
                    preview.src = plane.img;
                    preview.style.opacity = "1";
                }, 150);
            };

            const btnRow = document.createElement("div");
            btnRow.className = "dealer-buttons";

            const buyBtn = document.createElement("div");
            buyBtn.className = "dealer-btn-small";
            buyBtn.innerText = "Buy";

            const rentBtn = document.createElement("div");
            rentBtn.className = "dealer-btn-small";
            rentBtn.innerText = "Rent";

            const spawnBtn = document.createElement("div");
            spawnBtn.className = "dealer-btn-small";
            spawnBtn.innerText = "Spawn";

            if (locked) {
                buyBtn.classList.add("disabled");
                rentBtn.classList.add("disabled");
            } else {
                buyBtn.onclick = () => {
                    fetch(`https://${GetParentResourceName()}/dealerBuy`, {
                        method: "POST",
                        body: JSON.stringify({ model: plane.model })
                    });
                    document.body.style.display = "none";
                    dealerBg.style.display = "none";
                };

                rentBtn.onclick = () => {
                    fetch(`https://${GetParentResourceName()}/dealerRent`, {
                        method: "POST",
                        body: JSON.stringify({ model: plane.model })
                    });
                    document.body.style.display = "none";
                    dealerBg.style.display = "none";
                };
            }

            if (!owned) {
                spawnBtn.classList.add("disabled");
            } else {
                spawnBtn.onclick = () => {
                    fetch(`https://${GetParentResourceName()}/dealerSpawnOwned`, {
                        method: "POST",
                        body: JSON.stringify({ model: plane.model })
                    });
                    document.body.style.display = "none";
                    dealerBg.style.display = "none";
                };
            }

            btnRow.appendChild(buyBtn);
            btnRow.appendChild(rentBtn);
            btnRow.appendChild(spawnBtn);

            div.appendChild(btnRow);
            dealerList.appendChild(div);
        });
    }
});

// BUTTONS
document.getElementById("dealerClose").onclick = function () {
    document.body.style.display = "none";
    dealerBg.style.display = "none";
    fetch(`https://${GetParentResourceName()}/dealerClose`, { method: "POST" });
};

document.getElementById("root-close").onclick = function () {
    document.body.style.display = "none";
    rootMenu.style.display = "none";
    fetch(`https://${GetParentResourceName()}/rootClose`, { method: "POST" });
};

document.getElementById("root-legal").onclick = function () {
    fetch(`https://${GetParentResourceName()}/rootLegal`, { method: "POST" });
};

document.getElementById("root-illegal").onclick = function () {
    fetch(`https://${GetParentResourceName()}/rootIllegal`, { method: "POST" });
};

document.getElementById("closeContract").onclick = function () {
    document.body.style.display = "none";
    contractBg.style.display = "none";
    fetch(`https://${GetParentResourceName()}/closeContract`, { method: "POST" });
};
