
function addMessage(msg)
{
    var area = document.getElementById("msg");
    if (area) {
        area.innerHTML += htmlEscape(msg) + '<br/>';
    }
}

function clearMessage()
{
    var area = document.getElementById("msg");
    if (area) {
        area.innerHTML = '';
    }
}

function htmlEscape(str) {
    return str.replace(/&/g, '&amp;')
        .replace(/</g, '&lt;')
        .replace(/>/g, '&gt;')
        .replace(/"/g, '&quot;')
        .replace(/'/g, '&#039;');
}

function render(json) {
    data = JSON.parse(json);
    if ('cardinfo-name' in data) {
        document.getElementById("cardinfo-name").innerHTML = data['cardinfo-name'];
        document.getElementById("cardinfo-backside-name").innerHTML = data['cardinfo-name'];
    }
    if ('cardinfo-birth' in data) {
        var birth = data['cardinfo-birth'];
        var year = birth / 10000 | 0;
        var month = birth % 10000 / 100 | 0;
        var day = birth % 100;
        var eraYear;
        var wareki;
        if (18680908 <= birth && birth < 19120730) {
            eraYear = '明治' + (year - 1867) + '年';
        } else if (19120730 <= birth && birth < 19261225) {
            eraYear = '大正' + (year - 1911) + '年';
        } else if (19261225 <= birth && birth < 19890108) {
            eraYear = '昭和' + (year - 1925) + '年';
        } else if (19890108 <= birth && birth < 20190501) {
            eraYear = '平成' + (year - 1988) + '年';
        } else {
            eraYear = '令和' + (year - 2018) + '年';
        }
        var wareki = eraYear + month + '月' + day + '日';
        wareki = wareki.replace(/(\D)1年/g, '$1元年')
                       .replace(/(\D)(\d)年/g, '$1 $2年')
                       .replace(/(\D)(\d)月/g, '$1 $2月')
                       .replace(/(\D)(\d)日/g, '$1 $2日');
        document.getElementById("cardinfo-birth").innerHTML = wareki + '生';
        document.getElementById("cardinfo-backside-birth").innerHTML = wareki + '生';
    }
    if ('cardinfo-addr' in data) {
        document.getElementById("cardinfo-addr").innerHTML = htmlEscape(data['cardinfo-addr']);
    }
    if ('cardinfo-sex' in data) {
        var sex = data['cardinfo-sex'];
        var elm = document.getElementById("cardinfo-sex");
        if (sex == '男' || sex == '男性') {
            elm.innerHTML = '男';
        } else if (sex == '女' || sex == '女性') {
            elm.innerHTML = '女';
        } else if (sex == '不明') {
            elm.innerHTML = '不明';
        } else if (sex == '適用不能') {
            elm.innerHTML = '不明';
        } else {
            elm.innerHTML = '不明';
        } 
    }
    if ('cardinfo-mynumber' in data) {
        var mynumber = data['cardinfo-mynumber'];
        document.getElementById("cardinfo-mynumber-cell-1").innerHTML = htmlEscape(mynumber.substr(0, 4));
        document.getElementById("cardinfo-mynumber-cell-2").innerHTML = htmlEscape(mynumber.substr(4, 4));
        document.getElementById("cardinfo-mynumber-cell-3").innerHTML = htmlEscape(mynumber.substr(8, 4));
    }
    if ('cardinfo-cert-expire' in data) {
        var certExpire = data['cardinfo-cert-expire'];
        var year = certExpire.substr(0, 4);
        var month = certExpire.substr(4, 2);
        var day = certExpire.substr(6, 2);
        document.getElementById("cardinfo-cert-expire").innerHTML = htmlEscape(year + "年" + month + "月" + day + "日");
    }
    if ('cardinfo-expire' in data) {
        var expire = data['cardinfo-expire'];
        var year = expire.substr(0, 4);
        var month = expire.substr(4, 2);
        var day = expire.substr(6, 2);
        var expireDate = year + "年" + month + "月" + day + "日";
        expireDate = expireDate.replace(/年0(\d)月/g, '年 $1月')
                               .replace(/月0(\d)日/g, '月 $1日');
        document.getElementById("cardinfo-expire").innerHTML = htmlEscape(expireDate + "まで有効");
    }
    if ('cardinfo-photo' in data) {
        document.getElementById("cardinfo-photo").src = data['cardinfo-photo'];
    }

}

