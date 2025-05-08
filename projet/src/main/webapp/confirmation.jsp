<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Réservation confirmée | AutoLoc</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        :root {
            --primary-color: #28a745;
            --secondary-color: #218838;
            --blue-color: #007bff;
            --blue-hover: #0069d9;
            --light-color: #f8f9fa;
            --dark-color: #343a40;
            --border-radius: 8px;
        }
        
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        
        body {
            background-color: #f5f7fa;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            padding: 20px;
        }
        
        .success-container {
            background: white;
            border-radius: var(--border-radius);
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            padding: 40px;
            max-width: 600px;
            width: 100%;
            text-align: center;
            animation: fadeIn 0.5s ease-out;
        }
        
        .success-icon {
            font-size: 60px;
            color: var(--primary-color);
            margin-bottom: 20px;
            animation: bounce 1s;
        }
        
        h2 {
            color: var(--dark-color);
            margin-bottom: 20px;
            font-size: 28px;
            font-weight: 600;
        }
        
        .success-message {
            color: #495057;
            margin-bottom: 30px;
            font-size: 16px;
            line-height: 1.6;
        }
        
        .btn {
            display: inline-block;
            padding: 12px 24px;
            background-color: var(--blue-color);
            color: white;
            text-decoration: none;
            border-radius: var(--border-radius);
            font-weight: 500;
            transition: all 0.3s ease;
            border: none;
            cursor: pointer;
            font-size: 16px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        
        .btn:hover {
            background-color: var(--blue-hover);
            transform: translateY(-2px);
            box-shadow: 0 6px 12px rgba(0, 0, 0, 0.15);
        }
        
        .btn i {
            margin-right: 8px;
        }
        
        /* Animations */
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        @keyframes bounce {
            0%, 20%, 50%, 80%, 100% { transform: translateY(0); }
            40% { transform: translateY(-20px); }
            60% { transform: translateY(-10px); }
        }
        
        /* Responsive adjustments */
        @media (max-width: 576px) {
            .success-container {
                padding: 30px 20px;
            }
            
            h2 {
                font-size: 24px;
            }
            
            .btn {
                padding: 10px 20px;
            }
        }
    </style>
</head>
<body>
    <div class="success-container">
        <div class="success-icon">
            <i class="fas fa-check-circle"></i>
        </div>
        <h2>Votre réservation a été enregistrée avec succès !</h2>
        <p class="success-message">
            Merci d'avoir choisi nos services. Vous recevrez un email de confirmation avec les détails de votre réservation.
            Pour toute question, n'hésitez pas à nous contacter.
        </p>
        <a href="home.jsp" class="btn">
            <i class="fas fa-home"></i> Retour à l'accueil
        </a>
    </div>
</body>
</html>