<?php
/*
 * The MIT License
 *
 * Copyright 2020 Juliano Maciel Ferreira.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */
/*
|--------------------------------------------------------------------------
| Application Routes
|--------------------------------------------------------------------------
|
| Here is where you can register all of the routes for an application.
| It is a breeze. Simply tell Lumen the URIs it should respond to
| and give it the Closure to call when that URI is requested.
|
*/

$router->get('/', function () use ($router) {
    return $router->app->version();
});

$router->group([
    'prefix' => 'api'
], function ($router) {

    // User Register Route => /api/register
    $router->post('register', 'AuthController@register');

    // User Login Route  => /api/login
    $router->post('login', 'AuthController@login');

    // User Logout Route  => /api/logout
    $router->post('logout', 'AuthController@logout');

    // Refresh Token Route => /api/refresh
    $router->post('refresh', 'AuthController@refresh');

    // User Profile Route  => /api/profile
    $router->get('profile', 'UserController@profile');

    // User by id Route => /api/users/1
    $router->get('users/{id}', 'UserController@get');

    // All Users Route => /api/users
    $router->get('users', 'UserController@list');

    // Article Routes
    $router->get('articles', "ArticlesController@list");
    $router->get('articles/by-user/{user_id}', "ArticlesController@listByUser");
    $router->get('articles/{id}', "ArticlesController@get");
    $router->post('articles', "ArticlesController@create");
    $router->put('articles/{id}', "ArticlesController@put");
    $router->delete('articles/{id}', "ArticlesController@delete");
});
