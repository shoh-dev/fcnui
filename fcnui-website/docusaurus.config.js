// @ts-check
// `@type` JSDoc annotations allow editor autocompletion and type checking
// (when paired with `@ts-check`).
// There are various equivalent ways to declare your Docusaurus config.
// See: https://docusaurus.io/docs/api/docusaurus-config

import {themes as prismThemes} from 'prism-react-renderer';

/** @type {import('@docusaurus/types').Config} */
const config = {
    title: 'Flutter cn/ui',
    tagline: 'shadcn/ui port to flutter',
    favicon: 'img/favicon.ico',

    // Set the production url of your site here
    url: 'https://fcnui.shoh.dev/',
    // Set the /<baseUrl>/ pathname under which your site is served
    // For GitHub pages deployment, it is often '/<projectName>/'
    baseUrl: '/',

    // GitHub pages deployment config.
    // If you aren't using GitHub pages, you don't need these.
    organizationName: 'shoh.dev', // Usually your GitHub org/user name.
    projectName: 'fcnui', // Usually your repo name.

    onBrokenLinks: 'ignore',
    onBrokenMarkdownLinks: 'warn',

    // Even if you don't use internationalization, you can use this field to set
    // useful metadata like html lang. For example, if your site is Chinese, you
    // may want to replace "en" with "zh-Hans".
    i18n: {
        defaultLocale: 'en',
        locales: ['en'],
    },

    presets: [
        [
            'classic',
            /** @type {import('@docusaurus/preset-classic').Options} */
            ({
                docs: {
                    sidebarPath: './sidebars.js',
                    // Please change this to your repo.
                    // Remove this to remove the "edit this page" links.
                    // editUrl:
                    //     'https://github.com/facebook/docusaurus/tree/main/packages/create-docusaurus/templates/shared/',
                },
                theme: {
                    customCss: './src/css/custom.css',
                },
            }),
        ],
    ],

    themeConfig:
    /** @type {import('@docusaurus/preset-classic').ThemeConfig} */
        ({
            // Replace with your project's social card
            image: 'img/docusaurus-social-card.jpg',
            navbar: {
                title: 'Home',
                logo: {
                    alt: 'fcnui logo',
                    src: 'img/logo.svg',
                },
                items: [
                    {
                        type: 'docSidebar',
                        sidebarId: 'tutorialSidebar',
                        position: 'left',
                        label: 'Docs',
                    },
                    {
                        href: 'https://pub.dev/packages/fcnui',
                        label: 'pub.dev',
                        position: 'right',
                        target: '_blank',
                    },
                    {
                        href: 'https://github.com/shoh-dev/fcnui',
                        label: 'GitHub',
                        position: 'right',
                        target: '_blank',
                    },
                ],
            },
            footer: {
                style: 'dark',
                links: [
                    {
                        title: 'Docs',
                        items: [
                            {
                                label: 'About',
                                to: '/docs/',
                            },
                            {
                                label: 'Getting Started',
                                to: '/docs/get_started',
                            },
                            {
                                label: 'Components',
                                to: '/docs/category/components',
                            },
                        ],
                    },
                    {
                        title: 'Community',
                        items: [
                            {
                                label: 'Email',
                                href: 'mailto:komiljonovshohjahon1@gmail.com',
                            },
                            {
                                label: 'Telegram',
                                href: 'https://t.me/shohdotdev',
                            },
                            {
                                label: 'Twitter',
                                href: 'https://twitter.com/shoh_dev',
                            },
                        ],
                    },
                    {
                        title: 'More',
                        items: [
                            {
                                label: 'GitHub',
                                href: 'https://github.com/shoh-dev/fcnui',
                            },
                            {
                                label: 'shoh.dev',
                                href: 'https://shoh.dev',
                            },
                        ],
                    },
                ],
            },
            prism: {
                theme: prismThemes.oneLight,
                darkTheme: prismThemes.oneDark,
                additionalLanguages: ['dart', 'yaml', 'bash'],
            },
            algolia: {
                // The application ID provided by Algolia
                appId: 'G0D9R4FES4',

                // Public API key: it is safe to commit it
                apiKey: 'c0d302d40688de740dba058cf1830b32',

                indexName: 'fcnui',

                // // Optional: see doc section below
                // contextualSearch: true,
                //
                // // Optional: Specify domains where the navigation should occur through window.location instead on history.push. Useful when our Algolia config crawls multiple documentation sites and we want to navigate with window.location.href to them.
                // externalUrlRegex: 'external\\.com|domain\\.com',
                //
                // // Optional: Replace parts of the item URLs from Algolia. Useful when using the same search index for multiple deployments using a different baseUrl. You can use regexp or string in the `from` param. For example: localhost:3000 vs myCompany.com/docs
                // replaceSearchResultPathname: {
                //     from: '/docs/', // or as RegExp: /\/docs\//
                //     to: '/',
                // },
                //
                // // Optional: Algolia search parameters
                // searchParameters: {},
                //
                // // Optional: path for search page that enabled by default (`false` to disable it)
                // searchPagePath: 'search',
                //
                // //... other Algolia params
            }
        }),
};

export default config;
