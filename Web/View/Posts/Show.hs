module Web.View.Posts.Show where
import Web.View.Prelude
import qualified Text.MMark as MMark

data ShowView = ShowView { post :: Include "comments" Post }

instance View ShowView where
    html ShowView { .. } = [hsx|
        {breadcrumb}
        <h1>{post.title}</h1>
        <p>{post.createdAt |> dateTime}</p>
        <div>{post.body |> renderMarkdown}</div>

        <a href={NewCommentAction post.id}>Add Comment </a>

        <div>{forEach post.comments renderComment}</div>

    |]
        where
            breadcrumb = renderBreadcrumb
                            [ breadcrumbLink "Posts" PostsAction
                            , breadcrumbText "Show Post"
                            ]

renderMarkdown text = k $ text |> MMark.parse ""
                where k (Left error) = "Something went wrong"
                      k (Right md) = MMark.render md |> tshow |> preEscapedToHtml

renderComment comment = [hsx| 
                        <div class ="mt-4">
                            <h5>{comment.author}</h5>
                            <p>{comment.body}</p>
                          </div>
                        |]