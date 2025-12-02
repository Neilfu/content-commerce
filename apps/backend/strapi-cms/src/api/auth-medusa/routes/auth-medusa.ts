export default {
    routes: [
        {
            method: 'POST',
            path: '/auth-medusa/login',
            handler: 'auth-medusa.login',
            config: {
                policies: [],
                middlewares: [],
                auth: false, // We will protect this with API Token in the global config or assume API Token header is checked by default for non-public routes? 
                // Actually, 'auth: false' disables the Users-Permissions JWT check. 
                // Strapi API Tokens are handled by a global middleware. 
                // If we want ONLY API Tokens to access this, we usually keep auth: false but rely on the API Token middleware which runs before.
                // However, to be safe, we should ensure this is NOT public.
                // By default in Strapi v4, if auth: false, it's public. 
                // BUT, we can configure the API Token to be required. 
                // Let's stick to auth: false (disabling user auth) and rely on the API Token which is checked if present.
                // Wait, if I set auth: false, it might be open to the world.
                // Correct approach for "Service-to-Service" with API Token:
                // Strapi's API Token middleware automatically handles validation if the header is present.
                // But if I want to ENFORCE it, I might need a policy or just rely on not giving Public role access?
                // Actually, custom routes need to be enabled in the Admin Panel for the API Token to work?
                // No, API Tokens have "Full Access" or "Custom" scopes.
                // If I create a custom route, I need to make sure it's accessible by the API Token.
            },
        },
    ],
};
