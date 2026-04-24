window.addEventListener('message', function(e) {
    if (e.data.action === 'openBank') {
        document.body.style.display = 'block';

        document.getElementById('personal').innerHTML = "£" + e.data.personal;

        let jointHTML = "";
        e.data.joint.forEach(acc => {
            jointHTML += `
                <div>
                    <b>${acc.account_name}</b> - £${acc.balance}
                    <input id="jd${acc.id}" placeholder="Amount">
                    <button onclick="jointDeposit(${acc.id})">Deposit</button>
                    <button onclick="jointWithdraw(${acc.id})">Withdraw</button>
                </div>
            `;
        });
        document.getElementById('joint').innerHTML = jointHTML;

        if (e.data.society) {
            document.getElementById('society').innerHTML = `
                <b>${e.data.society.job}</b> - £${e.data.society.balance}
                <input id="sd" placeholder="Amount">
                <button onclick="societyDeposit()">Deposit</button>
                <button onclick="societyWithdraw()">Withdraw</button>
            `;
        } else {
            document.getElementById('society').innerHTML = "No society account";
        }
    }

    if (e.data.action === 'closeBank') {
        document.body.style.display = 'none';
    }
});

function jointDeposit(id) {
    fetch(`https://${GetParentResourceName()}/jointDeposit`, {
        method: 'POST',
        body: JSON.stringify({
            accountId: id,
            amount: document.getElementById('jd'+id).value
        })
    });
}

function jointWithdraw(id) {
    fetch(`https://${GetParentResourceName()}/jointWithdraw`, {
        method: 'POST',
        body: JSON.stringify({
            accountId: id,
            amount: document.getElementById('jd'+id).value
        })
    });
}

function societyDeposit() {
    fetch(`https://${GetParentResourceName()}/societyDeposit`, {
        method: 'POST',
        body: JSON.stringify({
            amount: document.getElementById('sd').value
        })
    });
}

function societyWithdraw() {
    fetch(`https://${GetParentResourceName()}/societyWithdraw`, {
        method: 'POST',
        body: JSON.stringify({
            amount: document.getElementById('sd').value
        })
    });
}

document.getElementById('close').onclick = function() {
    fetch(`https://${GetParentResourceName()}/close`, { method: 'POST' });
};
