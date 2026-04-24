window.onload = () => {
    const safeHide = (id) => {
        const el = document.getElementById(id);
        if (el) el.classList.add("hidden");
    };

    safeHide("job-menu");
    safeHide("job-type-menu");
    safeHide("dealer-wrapper");
    safeHide("xp-wrapper");
    safeHide("damage-wrapper");
};

let dealerState = {
    trucks: [],
    level: 1,
    owned: [],
    selected: null
};

window.addEventListener("message", function(e) {
    const action = e.data.action;

    if (action === "hideAll") {
        ["job-menu","job-type-menu","dealer-wrapper","xp-wrapper","damage-wrapper"].forEach(id => {
            const el = document.getElementById(id);
            if (el) el.classList.add("hidden");
        });
        return;
    }

    if (action === "openJobMenu") {
        document.getElementById("job-menu")?.classList.remove("hidden");
        return;
    }

    if (action === "closeJobMenu") {
        document.getElementById("job-menu")?.classList.add("hidden");
        document.getElementById("job-type-menu")?.classList.add("hidden");
        return;
    }

    if (action === "openDealership") {
        dealerState.trucks = e.data.trucks;
        dealerState.level = e.data.level;
        dealerState.owned = e.data.owned;

        document.getElementById("dealer-wrapper")?.classList.remove("hidden");
        buildDealerList();
        if (dealerState.trucks[0]) selectTruck(dealerState.trucks[0].model);
        return;
    }

    if (action === "xpBar") {
        showXPBar(e.data.level, e.data.next, e.data.xp, e.data.needed, e.data.gain);
        return;
    }

    if (action === "updateMergedHealth") {
        const wrap = document.getElementById("damage-wrapper");
        const bar = document.getElementById("merged-health-bar");
        const percent = document.getElementById("merged-health-percent");

        if (!wrap || !bar || !percent) return;

        const vRaw = e.data.merged;
        if (vRaw < 0) {
            wrap.classList.add("hidden");
            return;
        }

        const v = Math.max(0, Math.min(100, Math.floor(vRaw)));

        wrap.classList.remove("hidden");

        bar.style.width = v + "%";
        percent.innerText = v + "%";

        if (v > 60) bar.style.background = "green";
        else if (v > 30) bar.style.background = "yellow";
        else bar.style.background = "red";

        return;
    }
});

document.getElementById("job-start").onclick = () => {
    document.getElementById("job-menu").classList.add("hidden");
    document.getElementById("job-type-menu").classList.remove("hidden");
};

document.getElementById("job-close").onclick = () => {
    fetch(`https://${GetParentResourceName()}/closeJob`, { method: "POST" });
};

document.getElementById("job-legal").onclick = () => {
    fetch(`https://${GetParentResourceName()}/startJob`, { method: "POST" });
    document.getElementById("job-type-menu").classList.add("hidden");
};

document.getElementById("job-illegal").onclick = () => {
    fetch(`https://${GetParentResourceName()}/illegalJob`, { method: "POST" });
    document.getElementById("job-type-menu").classList.add("hidden");
};

document.getElementById("job-type-close").onclick = () => {
    document.getElementById("job-type-menu").classList.add("hidden");
    document.getElementById("job-menu").classList.remove("hidden");
};

function buildDealerList() {
    const list = document.getElementById("dealer-list");
    list.innerHTML = "";

    dealerState.trucks.forEach(t => {
        const item = document.createElement("div");
        item.className = "dealer-item";
        item.dataset.model = t.model;

        const left = document.createElement("div");
        left.innerText = t.label;

        const right = document.createElement("div");

        const owned = dealerState.owned.includes(t.model);
        const locked = dealerState.level < t.level;

        if (owned) {
            const span = document.createElement("span");
            span.className = "dealer-owned";
            span.innerText = "OWNED";
            right.appendChild(span);
        } else if (locked) {
            const span = document.createElement("span");
            span.className = "dealer-lock";
            span.innerText = "LVL " + t.level;
            right.appendChild(span);
        }

        item.appendChild(left);
        item.appendChild(right);

        item.onclick = () => selectTruck(t.model);

        list.appendChild(item);
    });
}

function selectTruck(model) {
    dealerState.selected = model;

    document.querySelectorAll(".dealer-item").forEach(el => {
        el.classList.remove("active");
        if (el.dataset.model === model) el.classList.add("active");
    });

    const t = dealerState.trucks.find(x => x.model === model);
    if (!t) return;

    document.getElementById("dealer-image").style.backgroundImage = `url('${t.render}')`;
    document.getElementById("dealer-name").innerText = t.label;
    document.getElementById("dealer-level").innerText = "Required Level: " + t.level;
    document.getElementById("dealer-price").innerText = "Purchase: £" + t.price.toLocaleString();
    document.getElementById("dealer-rent").innerText = "Rent: £" + t.rent.toLocaleString();

    const locked = dealerState.level < t.level;
    const owned = dealerState.owned.includes(t.model);

    const buy = document.getElementById("btn-buy");
    const rent = document.getElementById("btn-rent");
    const spawn = document.getElementById("btn-spawn");

    buy.classList.remove("disabled");
    rent.classList.remove("disabled");
    spawn.classList.remove("disabled");

    if (locked) {
        buy.classList.add("disabled");
        rent.classList.add("disabled");
        spawn.classList.add("disabled");
    } else if (owned) {
        buy.classList.add("disabled");
        rent.classList.add("disabled");
    } else {
        spawn.classList.add("disabled");
    }
}

document.getElementById("btn-buy").onclick = () => {
    if (document.getElementById("btn-buy").classList.contains("disabled")) return;
    fetch(`https://${GetParentResourceName()}/dealershipBuy`, {
        method: "POST",
        body: JSON.stringify({ model: dealerState.selected })
    });
};

document.getElementById("btn-rent").onclick = () => {
    if (document.getElementById("btn-rent").classList.contains("disabled")) return;
    fetch(`https://${GetParentResourceName()}/dealershipRent`, {
        method: "POST",
        body: JSON.stringify({ model: dealerState.selected })
    });
};

document.getElementById("btn-spawn").onclick = () => {
    if (document.getElementById("btn-spawn").classList.contains("disabled")) return;
    fetch(`https://${GetParentResourceName()}/dealershipSpawn`, {
        method: "POST",
        body: JSON.stringify({ model: dealerState.selected })
    });
};

document.getElementById("btn-close").onclick = () => {
    document.getElementById("dealer-wrapper").classList.add("hidden");
    fetch(`https://${GetParentResourceName()}/dealershipClose`, { method: "POST" });
};

function showXPBar(level, nextLevel, xp, needed, gain) {
    const wrap = document.getElementById("xp-wrapper");
    const left = document.getElementById("xp-left");
    const right = document.getElementById("xp-right");
    const fill = document.getElementById("xp-fill");
    const text = document.getElementById("xp-text");
    const shock = document.getElementById("xp-shockwave");
    const burst = document.getElementById("xp-burst");

    left.innerText = level;
    right.innerText = nextLevel;

    wrap.classList.remove("hidden");
    setTimeout(() => wrap.style.opacity = 1, 10);

    fill.style.width = "0%";
    setTimeout(() => fill.style.width = ((xp / needed) * 100) + "%", 150);

    text.innerText = xp + " / " + needed;

    if (gain > 0) {
        burst.classList.remove("hidden");
        burst.style.opacity = 1;
        setTimeout(() => burst.style.opacity = 0, 150);
        setTimeout(() => burst.classList.add("hidden"), 400);

        shock.classList.remove("hidden");
        shock.style.opacity = 1;
        shock.style.transform = "translateX(-50%) scale(3)";
        setTimeout(() => {
            shock.style.opacity = 0;
            shock.style.transform = "translateX(-50%) scale(1)";
        }, 500);
        setTimeout(() => shock.classList.add("hidden"), 700);
    }

    setTimeout(() => {
        wrap.style.opacity = 0;
        setTimeout(() => wrap.classList.add("hidden"), 300);
    }, 3500);
}
