export default {
    routes: [
        {
            method: 'GET',
            path: '/verification-tokens',
            handler: 'verification-token.find',
            config: {
                policies: [],
                middlewares: [],
            },
        },
        {
            method: 'GET',
            path: '/verification-tokens/:id',
            handler: 'verification-token.findOne',
            config: {
                policies: [],
                middlewares: [],
            },
        },
        {
            method: 'POST',
            path: '/verification-tokens',
            handler: 'verification-token.create',
            config: {
                policies: [],
                middlewares: [],
            },
        },
        {
            method: 'PUT',
            path: '/verification-tokens/:id',
            handler: 'verification-token.update',
            config: {
                policies: [],
                middlewares: [],
            },
        },
        {
            method: 'DELETE',
            path: '/verification-tokens/:id',
            handler: 'verification-token.delete',
            config: {
                policies: [],
                middlewares: [],
            },
        },
    ],
};
