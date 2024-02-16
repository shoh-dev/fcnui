import clsx from 'clsx';
import Heading from '@theme/Heading';
import styles from './styles.module.css';

const FeatureList = [
  {
    title: 'Easy to Use',
    Svg: require('@site/static/img/terminal.svg').default,
    description: (
      <>
          Simple command line tool that takes full control over installed components.
      </>
    ),
  },
  {
    title: 'Standalone Components',
    Svg: require('@site/static/img/component.svg').default,
    description: (
      <>
        Components that can be edited by your preference after installing.
      </>
    ),
  },
  {
    title: 'Built in Theme Support',
    Svg: require('@site/static/img/color-palette.svg').default,
    description: (
      <>
          Use built-in themes or create your own to customize your components.
          Built-in themes get   use of flex-color-scheme(pub.dev)
      </>
    ),
  },
];

function Feature({Svg, title, description}) {
  return (
    <div className={clsx('col col--4')}>
      <div className="text--center">
        <Svg className={styles.featureSvg} role="img" />
      </div>
      <div className="text--center padding-horiz--md">
        <Heading as="h3">{title}</Heading>
        <p>{description}</p>
      </div>
    </div>
  );
}

export default function HomepageFeatures() {
  return (
    <section className={styles.features}>
      <div className="container">
        <div className="row">
          {FeatureList.map((props, idx) => (
            <Feature key={idx} {...props} />
          ))}
        </div>
      </div>
    </section>
  );
}
