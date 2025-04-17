import fs from 'fs/promises';
import axios from 'axios';

const main = async () => {
    const url = 'https://ja.wikipedia.org/w/api.php';
    const params = {
        action: 'query',
        format: 'json',
        list: 'random',
        rnnamespace: 0,
    };
    const { data: randomData } = await axios.get(url, { params });
    const randomArticle = randomData.query.random[0];
    const { id, title } = randomArticle;
    const articleUrl = `https://ja.wikipedia.org/wiki/${encodeURIComponent(title)}`;
    const { data: articleData } = await axios.get(url, {
        params: {
            action: 'query',
            format: 'json',
            prop: 'extracts',
            explaintext: true,
            exsectionformat: 'plain',
            pageids: id,
        },
    });
    const { extract } = articleData.query.pages[String(id)];
    const firstSentence = extract?.split('。')?.[0]?.normalize('NFKC')?.trim();
    const firstSentenceShort = firstSentence?.replace(/[\(].*?[\)]/g, ''); // () 内を削除
    const titleShort = title?.replace(/[\(].*?[\)]/g, ''); // () 内を削除
    const description = firstSentenceShort
        .replaceAll(' ', '')
        .replace(/^.*は、/, '')
        .replace(`${titleShort}は`, '')
        .replace(/である$/, '');
    if (description.includes('\n')) return;
    const outputText = `%F{green}${title}%f ${description}`;
    await fs.writeFile('/Users/hideo54/random-wikipedia-article.txt', outputText, 'utf-8');
};

main();
