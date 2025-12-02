export default [
  'strapi::logger',
  'strapi::errors',
  'strapi::security',
  'strapi::cors',
  'strapi::poweredBy',
  'strapi::query',
  {
    name: 'strapi::body',
    config: {
      formLimit: '256mb', // increase limit
      jsonLimit: '256mb', // increase limit
      textLimit: '256mb', // increase limit
      formidable: {
        maxFileSize: 200 * 1024 * 1024, // multipart data, increase limit
      },
    },
  },
  'strapi::session',
  'strapi::favicon',
  'strapi::public',
];
