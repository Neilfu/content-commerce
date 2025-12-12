export default {
    routes: [
        {
            method: 'GET',
            path: '/user-profiles',
            handler: 'user-profile.find',
            config: {
                policies: [],
                middlewares: [],
            },
        },
        {
            method: 'GET',
            path: '/user-profiles/:id',
            handler: 'user-profile.findOne',
            config: {
                policies: [],
                middlewares: [],
            },
        },
        {
            method: 'POST',
            path: '/user-profiles',
            handler: 'user-profile.create',
            config: {
                policies: [],
                middlewares: [],
            },
        },
        {
            method: 'PUT',
            path: '/user-profiles/:id',
            handler: 'user-profile.update',
            config: {
                policies: [],
                middlewares: [],
            },
        },
        {
            method: 'DELETE',
            path: '/user-profiles/:id',
            handler: 'user-profile.delete',
            config: {
                policies: [],
                middlewares: [],
            },
        },
    ],
};
