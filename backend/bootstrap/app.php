<?php

use Illuminate\Foundation\Application;
use Illuminate\Foundation\Configuration\Exceptions;
use Illuminate\Foundation\Configuration\Middleware;

return Application::configure(basePath: dirname(__DIR__))
    ->withRouting(
        web: __DIR__.'/../routes/web.php',
        api: __DIR__.'/../routes/api.php',
        commands: __DIR__.'/../routes/console.php',
        health: '/up',
    )
    ->withMiddleware(function (Middleware $middleware): void {
        // Appends the stateful API middleware group if needed
        $middleware->statefulApi(); 
        
        // Exclude API routes from CSRF verification (vital for Flutter API requests)
        $middleware->validateCsrfTokens(except: [
            'api/*', 
        ]);
    })
    ->withExceptions(function (Exceptions $exceptions): void {
        //
    })
    ->create(); // This is now correctly placed at the absolute end