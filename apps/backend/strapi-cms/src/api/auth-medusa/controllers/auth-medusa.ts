/**
 * A set of functions called "actions" for `auth-medusa`
 */

import { randomBytes } from 'crypto';

export default {
    async login(ctx) {
        const { email, external_id, username } = ctx.request.body;

        if (!email || !external_id) {
            return ctx.badRequest('Email and external_id are required');
        }

        try {
            // 1. Check if user exists
            const user = await strapi.db.query('plugin::users-permissions.user').findOne({
                where: { email },
            });

            if (user) {
                // User exists, issue JWT
                const token = strapi.plugin('users-permissions').service('jwt').issue({
                    id: user.id,
                });

                return {
                    jwt: token,
                    user: {
                        id: user.id,
                        username: user.username,
                        email: user.email,
                    },
                };
            }

            // 2. User does not exist, create new user
            const pluginStore = await strapi.store({
                type: 'plugin',
                name: 'users-permissions',
            });

            const settings = await pluginStore.get({ key: 'advanced' }) as { default_role: string };
            const role = await strapi
                .query('plugin::users-permissions.role')
                .findOne({ where: { type: settings.default_role } });

            if (!role) {
                return ctx.badRequest('Default role not found');
            }

            // Generate a random password since they won't use it (they use Medusa)
            const password = randomBytes(16).toString('hex');

            const newUser = await strapi.plugin('users-permissions').service('user').add({
                email,
                username: username || email.split('@')[0],
                password,
                role: role.id,
                confirmed: true,
                provider: 'local',
                medusa_id: external_id,
            });

            const token = strapi.plugin('users-permissions').service('jwt').issue({
                id: newUser.id,
            });

            return {
                jwt: token,
                user: {
                    id: newUser.id,
                    username: newUser.username,
                    email: newUser.email,
                },
            };

        } catch (err) {
            ctx.body = err;
        }
    },
};

