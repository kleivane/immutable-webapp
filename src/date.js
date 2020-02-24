import moment from 'moment'

const FORMAT = 'HH:mm:ss DD.MM.YYYY';

const dateformat =  (time) => {
  const t = moment(time);
  return t.isValid() ? t.format(FORMAT) : `${time} (uformattert)`;
}

export default dateformat;
