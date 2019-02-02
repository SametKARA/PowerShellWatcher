function Get-HTMLTableStyle ()
{
    Return  "<style type=`"text/css`">``
            .tg  {border-collapse:collapse;border-spacing:0;border-color:#ccc;margin:0px auto;}`
            .tg td{font-family:Arial, sans-serif;font-size:14px;padding:10px 5px;border-style:solid;border-width:0px;overflow:hidden;word-break:normal;border-top-width:1px;border-bottom-width:1px;border-color:#ccc;color:#333;background-color:#fff;}`
            .tg th{font-family:Arial, sans-serif;font-size:14px;font-weight:normal;padding:10px 5px;border-style:solid;border-width:0px;overflow:hidden;word-break:normal;border-top-width:1px;border-bottom-width:1px;border-color:#ccc;color:#333;background-color:#f0f0f0;}`
            .tg .tg-EvenColumn{background-color:#f9f9f9;text-align:left;vertical-align:top}`
            .tg .tg-FirstRow_EvenColumn{background-color:#f9f9f9;font-weight:bold;text-align:center;vertical-align:top}`
            .tg .tg-FirstRow_OddColumn{font-weight:bold;text-align:center;vertical-align:top}`
            .tg .tg-FirstColumn{font-weight:bold;text-align:center;vertical-align:top}`
            .tg .tg-Header{font-weight:bold;text-align:center;vertical-align:top}`
            .tg .tg-OddColumn{text-align:left;vertical-align:top}`
            .tg-sort-header::-moz-selection{background:0 0}.tg-sort-header::selection{background:0 0}.tg-sort-header{cursor:pointer}.tg-sort-header:after{content:'';float:right;margin-top:7px;border-width:0 5px 5px;border-style:solid;border-color:#404040 transparent;visibility:hidden}.tg-sort-header:hover:after{visibility:visible}.tg-sort-asc:after,.tg-sort-asc:hover:after,.tg-sort-desc:after{visibility:visible;opacity:.4}.tg-sort-desc:after{border-bottom:none;border-width:5px 5px 0}@media screen and (max-width: 767px) {.tg {width: auto !important;}.tg col {width: auto !important;}.tg-wrap {overflow-x: auto;-webkit-overflow-scrolling: touch;margin: auto 0px;}}</style>"
}

function Get-HTMLTableHeader ([string] $Header, [int] $colspan)
{
    return "<div class=`"tg-wrap`">`
            <table id=`"tg-RrbVf`" class=`"tg`">`
            <tr>`
                <th class=`"tg-Header`" colspan=`"$colspan`">$Header</th>`
            </tr>"
}

function Add-HTMLTableRow ([string[]] $RowColumns, [switch] $FirstRow, [bool] $isFirstColumnBold = $false)
{
    [string] $Class = $null

    [int] $IndexStart = 0
 
    
    if($FirstRow)
    {
        $Class = "tg-FirstRow_OddColumn"
        $IndexStart = 2
    }
    else
    {
        $Class = "tg-OddColumn"
    }
    if($isFirstColumnBold)
    {
        $Class = "tg-FirstColumn"
    }

    [string] $Return = "<tr><td class=`"$Class`">$($RowColumns[0])</td>"

    [int] $ColumnNumber =  $RowColumns.Count
    
    for([int]$i = 1; $i -lt $ColumnNumber ; $i++)
    {
        $Class = @("tg-OddColumn","tg-EvenColumn","tg-FirstRow_OddColumn","tg-FirstRow_EvenColumn")[($i % 2) + $IndexStart]
        $Return += "<td class=`"$Class`">$($RowColumns[$i])</td>"
    }
    
    $Return += "</tr>"
    
    return $Return
}

function Get-HTMLTableFooter ()
{
    return "</table></div>"
}

function Get-HTMLTableSortScript ()
{
    return "<script charset=`"utf-8`">var TGSort=window.TGSort||function(n){`"use strict`";function r(n){return n.length}function t(n,t){if(n)for(var e=0,a=r(n);a>e;++e)t(n[e],e)}function e(n){return n.split(`"`").reverse().join(`"`")}function a(n){var e=n[0];return t(n,function(n){for(;!n.startsWith(e);)e=e.substring(0,r(e)-1)}),r(e)}function o(n,r){return-1!=n.map(r).indexOf(!0)}function u(n,r){return function(t){var e=`"`";return t.replace(n,function(n,t,a){return e=t.replace(r,`"`")+`".`"+(a||`"`").substring(1)}),l(e)}}function i(n){var t=l(n);return!isNaN(t)&&r(`"`"+t)+1>=r(n)?t:NaN}function s(n){var e=[];return t([i,m,g],function(t){var a;r(e)||o(a=n.map(t),isNaN)||(e=a)}),e}function c(n){var t=s(n);if(!r(t)){var o=a(n),u=a(n.map(e)),i=n.map(function(n){return n.substring(o,r(n)-u)});t=s(i)}return t}function f(n){var r=n.map(Date.parse);return o(r,isNaN)?[]:r}function v(n,r){r(n),t(n.childNodes,function(n){v(n,r)})}function d(n){var r,t=[],e=[];return v(n,function(n){var a=n.nodeName;`"TR`"==a?(r=[],t.push(r),e.push(n)):(`"TD`"==a||`"TH`"==a)&&r.push(n)}),[t,e]}function p(n){if(`"TABLE`"==n.nodeName){for(var e=d(n),a=e[0],o=e[1],u=r(a),i=u>1&&r(a[0])<r(a[1])?1:0,s=i+1,v=a[i],p=r(v),l=[],m=[],g=[],h=s;u>h;++h){for(var N=0;p>N;++N){r(m)<p&&m.push([]);var T=a[h][N],C=T.textContent||T.innerText||`"`";m[N].push(C.trim())}g.push(h-s)}var L=`"tg-sort-asc`",E=`"tg-sort-desc`",b=function(){for(var n=0;p>n;++n){var r=v[n].classList;r.remove(L),r.remove(E),l[n]=0}};t(v,function(n,t){l[t]=0;var e=n.classList;e.add(`"tg-sort-header`"),n.addEventListener(`"click`",function(){function n(n,r){var t=d[n],e=d[r];return t>e?a:e>t?-a:a*(n-r)}var a=l[t];b(),a=1==a?-1:+!a,a&&e.add(a>0?L:E),l[t]=a;var i=m[t],v=function(n,r){return a*i[n].localeCompare(i[r])||a*(n-r)},d=c(i);(r(d)||r(d=f(i)))&&(v=n);var p=g.slice();p.sort(v);for(var h=null,N=s;u>N;++N)h=o[N].parentNode,h.removeChild(o[N]);for(var N=s;u>N;++N)h.appendChild(o[s+p[N-s]])})})}}var l=parseFloat,m=u(/^(?:\s*)([+-]?(?:\d+)(?:,\d{3})*)(\.\d*)?$/g,/,/g),g=u(/^(?:\s*)([+-]?(?:\d+)(?:\.\d{3})*)(,\d*)?$/g,/\./g);n.addEventListener(`"DOMContentLoaded`",function(){for(var t=n.getElementsByClassName(`"tg`"),e=0;e<r(t);++e)try{p(t[e])}catch(a){}})}(document);</script>"
}

function ConvertTo-HTMLTable ([object] $Object, [string] $Header, [bool] $isFirstColumnBold = $false)
{
    $HTML = $Object | ConvertTo-Html

    $ColumnCount = ([regex]::Matches($HTML, "<col/>" )).count

    $Return = Get-HTMLTableHeader $Header $ColumnCount

    foreach ($line in $HTML)
    {
        if($line.StartsWith("<tr>"))
        {
            if($line.StartsWith("<tr><td>"))
            {
                $Return += Add-HTMLTableRow ($line.Remove($line.Length-10).Remove(0,8).Replace("</td><td>",",") -split ',') -isFirstColumnBold $isFirstColumnBold
            }
            else
            {
                $Return += Add-HTMLTableRow ($line.Remove($line.Length-10).Remove(0,8).Replace("</th><th>",",") -split ',') -FirstRow -isFirstColumnBold $isFirstColumnBold
            }
        }
    }

    $Return += Get-HTMLTableFooter

    return $Return
}

function New-HTMLReport ([object] $Object, [string] $Header, [bool] $isFirstColumnBold = $false)
{
    $Return = "<!DOCTYPE html PUBLIC `"-//W3C//DTD XHTML 1.0 Strict//EN`"  `"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd`">`
    <html xmlns=`"http://www.w3.org/1999/xhtml`">`
	    <head>`
		    <title>HTML TABLE</title>`
	    </head>"
    $Return += Get-HTMLTableStyle
    $Return += "<body>"
    $Return += ConvertTo-HTMLTable $Object $Header $isFirstColumnBold 
    $Return += "</body>"
    $Return += Get-HTMLTableSortScript
    $Return += "</html>"

    return $Return
}