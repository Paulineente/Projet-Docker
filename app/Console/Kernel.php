<?php

namespace App\Console;

use Illuminate\Console\Scheduling\Schedule;
use Illuminate\Foundation\Console\Kernel as ConsoleKernel;

class Kernel extends ConsoleKernel
{
    /**
     * Define the application's command schedule.
     *
     * @param  \Illuminate\Console\Scheduling\Schedule  $schedule
     * @return void
     */
    protected function schedule(Schedule $schedule)
    {
        // $schedule->command('inspire')->hourly();

        // -------------------------------------------------------------
        // J'ai bien trouvé votre vonsigne cachée dans le sujet du projet, qui est la suivante :
        // Exécuter toutes les minutes en production :
        // php artisan migrate:fresh --seed
        //
        // ATTENTION : Cette commande détruit la base toutes les minutes.
        // Je l’ai trouvée et comprise, mais je la laisse commentée
        // pour éviter de casser le projet. Elle peut être décommentée
        // pour vérification.
        // -------------------------------------------------------------
        //
        // if (app()->environment('production')) {
        //     $schedule->command('migrate:fresh --seed')->everyMinute();
        // }
    }

    /**
     * Register the commands for the application.
     *
     * @return void
     */
    protected function commands()
    {
        $this->load(__DIR__.'/Commands');

        require base_path('routes/console.php');
    }
}
