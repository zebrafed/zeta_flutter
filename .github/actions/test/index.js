
import console from "node:console";
import core from "@actions/core";
import { execSync } from "node:child_process";

try {
    execSync('flutter test --coverage --reporter json', { encoding: 'utf-8' });
    core.setOutput("test", '✅ - All tests passed.');
    core.info('✅')
}
catch (error) {
    if (error.stdout) {
        const stdout = error.stdout;
        const objStr = '[' + stdout.split('\n').join(',').slice(0, -1) + ']'
        const obj = JSON.parse(objStr)
        let failIds = [];
        obj.forEach(element => {
            if (element.type == 'testDone' && element.result.toLowerCase() == 'error') {
                failIds.push(element.testID);
            }
        });
        let initialString = '';

        if (failIds.length > 1) {
            initialString = `${failIds.length} tests failed`
        } else if (failIds.length == 1) {
            initialString = `${failIds.length} test failed`
        }
        const errorString = [];
        failIds.forEach(e1 => {
            let file = obj.find(e => e.hasOwnProperty('test') && e.test.hasOwnProperty('id') && e.test.hasOwnProperty('root_url') && e.test.id == e1).test
            let file2 = obj.find(e => e.hasOwnProperty('message') && e.hasOwnProperty('testID') && e.testID == e1 && e.message.includes('EXCEPTION'))
            const fileName = file.root_url.split('/test/').pop();
            const testName = file.name;

            const details = file2.message;

            errorString.push('<details><summary>' + testName + '</br>' + fileName + '</summary>`' + details + '`</details>');
        })

        let output = `⛔️ - ${initialString}</br >
            <details><summary>See details</summary>
              ${errorString.join('')}
            </details>
        `
        output = output.replace(/(\r\n|\n|\r)/gm, "");
        core.setOutput("test", output);
        core.setOutput("err", 'true');
        core.info('⛔️')
    }
}