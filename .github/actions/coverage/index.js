import console from "node:console";
import core from "@actions/core";
import { parse, sum } from 'lcov-utils'
import { readFileSync, writeFileSync } from "node:fs";
let oldCov = ''
try {
    oldCov = JSON.parse(readFileSync('coverage/old/coverage.json', 'utf8'));
} catch {
    console.log('Old coverage not found.')
}
try {
    const contents = readFileSync('coverage/lcov.info', 'utf8')
    const lcov = parse(contents)
    const digest = sum(lcov)
    let totalPercent = digest.lines;

    const arr = Object.values(lcov).map(e => {
        const fileName = e.sf;
        const percent = Math.round((e.lh / e.lf) * 1000) / 10;
        const passing = percent > 96 ? '✅' : '⛔️';
        return `<tr><td>${fileName}</td><td>${percent}%</td><td>${passing}</td></tr>`;
    })

    if (oldCov && oldCov.percent) {
        if (oldCov.percent > totalPercent) {
            totalPercent = totalPercent + '% (🔻 down from ' + oldCov.percent + ')'
        } else if (oldCov.percent < totalPercent) {
            totalPercent = totalPercent + '% (👆 up from ' + oldCov.percent + ')'
        } else {
            totalPercent = totalPercent + '% (no change)'
        }

    } else {
        totalPercent = totalPercent + '%';
    }

    const str = `📈 - Code coverage: ${totalPercent}
    <br>
    <details><summary>See details</summary>
    <table>
    <tr><th>File Name</th><th>%</th><th>Passing?</th></tr>
        ${arr.join('')}
    </table>
    </details>`;

    const output = str.replace(/(\r\n|\n|\r)/gm, "");


    core.setOutput("coverage", output);
    writeFileSync('coverage/new/coverage.json', `{percent:${totalPercent.replace(/%/g, "")}}`);
    core.info('✅')
}
catch (error) {
    core.setOutput("coverage", 'Fail');
    core.info('⛔️')
}