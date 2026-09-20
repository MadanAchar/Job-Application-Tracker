<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=1280">
    <title>404 - Page Not Found</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/global.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/animations.css">

    <style>
        body {
            margin: 0;
            background: var(--bg-primary);
            color: var(--text-primary);
            font-family: 'Inter', sans-serif;
        }

        .error-container {
            height: 100vh;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
        }

        .error-code {
            font-size: 120px;
            font-weight: 700;
            color: var(--text-muted);
            margin-bottom: 12px;
        }

        .error-message {
            font-size: 20px;
            color: var(--text-secondary);
            margin-bottom: 30px;
        }

        .back-btn {
            background: var(--accent);
            color: white;
            padding: 12px 24px;
            text-decoration: none;
            border-radius: var(--radius-sm);
            transition: 0.2s ease;
        }

        .back-btn:hover {
            background: var(--accent-hover);
        }
    </style>
</head>
<body>

<div class="error-container fadeIn">
    <div class="error-code">404</div>
    <div class="error-message">
        The page you are looking for does not exist.
    </div>

    <a class="back-btn"
       href="${pageContext.request.contextPath}/dashboard">
        Back to Dashboard
    </a>
</div>

</body>
</html>