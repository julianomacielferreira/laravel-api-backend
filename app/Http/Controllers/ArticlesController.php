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

namespace App\Http\Controllers;

use App\Article;
use Illuminate\Http\Request;

class ArticlesController extends Controller
{
    /**
     * Create a new controller instance.
     *
     * @return void
     */
    public function __construct()
    {
        $this->middleware('auth');
    }

    public function list()
    {
        return response()->json(['articles' => Article::all()]);
    }

    public function listByUser($user_id)
    {
        $articlesByUser = Article::where('user_id', $user_id)->get();

        return response()->json(['articles' => $articlesByUser]);
    }

    public function get($id)
    {
        try {

            $article = Article::findOrFail($id);

            return response()->json(['article' => $article], 200);
        } catch (\Exception $e) {

            return response()->json(['message' => 'Article not found!'], 404);
        }
    }

    public function create(Request $request)
    {
        $this->validate_request($request);

        $article = Article::create($request->all());

        return response()->json(['article' => $article, 'message' => 'CREATED'], 201);
    }

    public function put($id, Request $request)
    {

        $this->validate_request($request);

        try {

            $article = Article::findOrFail($id);
            $article->update($request->all());

            return response()->json(['article' => $article, 'message' => 'UPDATED'], 200);
        } catch (\Exception $e) {

            return response()->json(['message' => 'Article not found!'], 404);
        }
    }

    public function delete($id)
    {

        try {

            $article = Article::findOrFail($id);
            $article->delete();

            return response(['message' => 'DELETED'], 200);
        } catch (\Exception $e) {

            return response()->json(['message' => 'Article not found!'], 404);
        }
    }

    private function validate_request(Request $request)
    {

        $this->validate(
            $request,
            [
                'user_id' => 'required',
                'title' => 'required|string',
                'description' => 'required|string',
            ]
        );
    }
}
