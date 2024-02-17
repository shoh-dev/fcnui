type Props = {
    src: string,
    height: number,
}

export default function DefaultIframe(props: Props) {
    const height = props.height ? props.height : 300;
    return (
        <iframe src={props.src} width="100%" height={height}/>
    );
}